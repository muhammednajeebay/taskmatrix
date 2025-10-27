import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_matrix/core/theme/theme_cubit.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                final isDark = mode == ThemeMode.dark;
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: Text(isDark ? 'Dark theme enabled' : 'Light theme enabled'),
                  value: isDark,
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Organization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Manage Organization'),
              subtitle: const Text('Edit name, view domain key, logo'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => GoRouter.of(context).go('/settings/org'),
            ),
          ],
        ),
      ),
    );
  }
}
