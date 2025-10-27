import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_matrix/presentation/pages/dashboard_page.dart';
import 'package:task_matrix/presentation/pages/tasks_page.dart';
import 'package:task_matrix/presentation/pages/task_detail_page.dart';
import 'package:task_matrix/presentation/pages/leaderboard_page.dart';
import 'package:task_matrix/presentation/pages/notifications_page.dart';
import 'package:task_matrix/presentation/pages/settings_page.dart';
import 'package:task_matrix/presentation/pages/login_page.dart';
import 'package:task_matrix/presentation/pages/signup_admin_page.dart';
import 'package:task_matrix/presentation/pages/org_settings_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/signup-admin',
      builder: (context, state) => const SignupAdminPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _indexForLocation(state.fullPath ?? '/dashboard'),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
            NavigationDestination(
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications),
              label: 'Alerts',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/dashboard');
                break;
              case 1:
                context.go('/tasks');
                break;
              case 2:
                context.go('/leaderboard');
                break;
              case 3:
                context.go('/notifications');
                break;
              case 4:
                context.go('/settings');
                break;
            }
          },
        ),
      ),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const TasksPage(),
          routes: [
            GoRoute(
              path: ':taskId',
              builder: (context, state) =>
                  TaskDetailPage(taskId: state.pathParameters['taskId']!),
            ),
          ],
        ),
        GoRoute(
          path: '/leaderboard',
          builder: (context, state) => const LeaderboardPage(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/settings/org',
          builder: (context, state) => const OrgSettingsPage(),
        ),
      ],
    ),
  ],
);

int _indexForLocation(String location) {
  if (location.startsWith('/dashboard')) return 0;
  if (location.startsWith('/tasks')) return 1;
  if (location.startsWith('/leaderboard')) return 2;
  if (location.startsWith('/notifications')) return 3;
  if (location.startsWith('/settings')) return 4;
  return 0;
}
