import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_matrix/core/constants/app_config.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? error;
  const AuthState({required this.status, this.error});
  @override
  List<Object?> get props => [status, error];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(status: AuthStatus.unauthenticated));

  Future<void> signInWithEmailPassword(String email, String password) async {
    emit(const AuthState(status: AuthStatus.authenticating));
    final supabase = Supabase.instance.client;
    try {
      final res = await supabase.auth.signInWithPassword(email: email, password: password);
      final user = res.user;
      await _ensureUserRow(user);
      emit(const AuthState(status: AuthStatus.authenticated));
    } on AuthException catch (e) {
      emit(AuthState(status: AuthStatus.unauthenticated, error: e.message));
    } catch (e) {
      emit(AuthState(status: AuthStatus.unauthenticated, error: e.toString()));
    }
  }

  // Admin sign-up: creates auth user, attempts to create org, then links user as admin to org
  Future<void> signUpAdmin(String email, String password, String orgName, String orgDomainKey) async {
    emit(const AuthState(status: AuthStatus.authenticating));
    final supabase = Supabase.instance.client;
    try {
      final res = await supabase.auth.signUp(email: email, password: password);
      final user = res.user;
      if (user == null) {
        throw const AuthException('Sign-up failed');
      }

      // Domain key validation and organization resolution
      // 1) Check if an organization with this domain_key already exists
      String? orgId;
      final existing = await supabase
          .from('organizations')
          .select('id')
          .eq('domain_key', orgDomainKey)
          .maybeSingle();
      if (existing != null) {
        // Reuse existing org (prevents duplicate insert of domain_key)
        orgId = existing['id'] as String?;
      } else {
        // 2) No existing org — attempt to create a new organization
        try {
          final inserted = await supabase
              .from('organizations')
              .insert({
                'name': orgName,
                'domain_key': orgDomainKey,
              })
              .select('id')
              .maybeSingle();
          if (inserted != null) {
            orgId = inserted['id'] as String?;
          }
        } catch (e) {
          // If insert fails (e.g., RLS), emit a clear error
          emit(AuthState(
            status: AuthStatus.unauthenticated,
            error:
                'Unable to create organization (domain_key: ' + orgDomainKey + '). Please ensure the org exists or adjust RLS policies.',
          ));
          return;
        }
      }

      if (orgId == null) {
        emit(AuthState(
          status: AuthStatus.unauthenticated,
          error:
              'Organization not found or cannot be created (domain_key: ' + orgDomainKey + '). Please create it in Supabase and try again.',
        ));
        return;
      }

      // Insert the user row with admin role
      await supabase.from('users').insert({
        'id': user.id,
        'org_id': orgId,
        'email': user.email,
        'name': user.email?.split('@').first,
        'role': 'admin',
      });

      emit(const AuthState(status: AuthStatus.authenticated));
    } on AuthException catch (e) {
      emit(AuthState(status: AuthStatus.unauthenticated, error: e.message));
    } catch (e) {
      emit(AuthState(status: AuthStatus.unauthenticated, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    final supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _ensureUserRow(User? user) async {
    if (user == null) return;
    final supabase = Supabase.instance.client;
    try {
      // Check if a row exists
      final existing = await supabase
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();
      if (existing != null) {
        return; // already linked
      }
      // Get org_id by domain_key (Dev default)
      final org = await supabase
          .from('organizations')
          .select('id')
          .eq('domain_key', AppConfig.defaultOrgDomainKey)
          .maybeSingle();
      final orgId = org == null ? null : org['id'] as String?;
      if (orgId == null) {
        // If no org found, skip silently; app can handle org selection later
        return;
      }
      // Insert user row (RLS policy allows inserting own row)
      await supabase.from('users').insert({
        'id': user.id,
        'org_id': orgId,
        'email': user.email,
        'name': user.userMetadata == null ? (user.email?.split('@').first) : (user.userMetadata!['name'] ?? user.email?.split('@').first),
        'role': 'member',
      });
    } catch (_) {
      // ignore failures here; they can be addressed later
    }
  }
}
