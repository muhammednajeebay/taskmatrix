import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_matrix/presentation/bloc/auth/auth_cubit.dart';

class SignupAdminPage extends StatefulWidget {
  const SignupAdminPage({super.key});

  @override
  State<SignupAdminPage> createState() => _SignupAdminPageState();
}

class _SignupAdminPageState extends State<SignupAdminPage> {
  final _orgNameController = TextEditingController();
  final _orgDomainKeyController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _orgNameController.dispose();
    _orgDomainKeyController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Organization Admin')),
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (prev, curr) => prev.status != curr.status || prev.error != curr.error,
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            GoRouter.of(context).go('/dashboard');
          } else if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Organization Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _orgNameController,
                      decoration: const InputDecoration(
                        labelText: 'Organization Name',
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _orgDomainKeyController,
                      decoration: const InputDecoration(
                        labelText: 'Organization Domain Key',
                        hintText: 'e.g., acme-inc',
                        prefixIcon: Icon(Icons.domain),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Admin Account',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'admin@example.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final loading = state.status == AuthStatus.authenticating;
                        return ElevatedButton.icon(
                          onPressed: loading
                              ? null
                              : () async {
                                  final orgName = _orgNameController.text.trim();
                                  final orgDomainKey = _orgDomainKeyController.text.trim();
                                  final email = _emailController.text.trim();
                                  final password = _passwordController.text;
                                  final confirm = _confirmPasswordController.text;

                                  if ([orgName, orgDomainKey, email, password, confirm].any((v) => v.isEmpty)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please fill in all fields')), 
                                    );
                                    return;
                                  }
                                  if (password.length < 8) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Password must be at least 8 characters')),
                                    );
                                    return;
                                  }
                                  if (password != confirm) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Passwords do not match')),
                                    );
                                    return;
                                  }

                                  await context.read<AuthCubit>().signUpAdmin(
                                        email, password, orgName, orgDomainKey,
                                      );
                                },
                          icon: loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.admin_panel_settings),
                          label: Text(loading ? 'Creating...' : 'Create Admin & Org'),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => GoRouter.of(context).go('/login'),
                      child: const Text('Back to Login'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
