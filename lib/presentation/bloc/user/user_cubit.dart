import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String role;
  const UserProfile({required this.id, required this.name, required this.role});
  @override
  List<Object?> get props => [id, name, role];
}

class UserState extends Equatable {
  final List<UserProfile> users;
  const UserState(this.users);
  @override
  List<Object?> get props => [users];
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState([]));

  void loadUsers() {
    // TODO: integrate with Supabase in Phase 2/5
    emit(UserState([
      const UserProfile(id: '1', name: 'Alice', role: 'Admin'),
      const UserProfile(id: '2', name: 'Bob', role: 'Manager'),
    ]));
  }
}
