import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/features/notifications/presentation/notifications_screen.dart';
import 'package:kfazer3/src/features/settings/presentation/settings_screen.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/tasks/presentation/archive/archived_tasks_screen.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/task_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/preferences/workspace_preferences_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_list/workspace_list_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/workspace_screen.dart';
import 'package:kfazer3/src/routing/not_found_screen.dart';

enum AppRoute {
  //* sign in flow
  signIn,
  signInPage,
  //* main flow
  home,
  workspace,
  workspaceMenu,
  workspacePreferences, //! fullscreenDialog
  workspaceArchive, //! fullscreenDialog
  task, //! fullscreenDialog
  account, //! fullscreenDialog
  notifications, //! fullscreenDialog
  settings, //! fullscreenDialog
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location.contains('/signIn')) return '/';
      } else {
        if (!state.location.contains('/signIn')) return '/signIn';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        redirect: (state) =>
            '${state.location}/${SignInPage.values.first.name}',
      ),
      GoRoute(
        path: '/signIn/:page',
        name: AppRoute.signInPage.name,
        builder: (_, state) {
          final pageName = state.params['page']!;
          final page = SignInPage.values.firstWhere(
            (page) => page.name == pageName,
            orElse: () => SignInPage.values.first,
          );
          return SignInScreen(page: page);
        },
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (_, state) => const WorkspaceListScreen(),
        routes: [
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'notifications',
            name: AppRoute.notifications.name,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const NotificationsScreen(),
            ),
          ),
          GoRoute(
            path: 'settings',
            name: AppRoute.settings.name,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const SettingsScreen(),
            ),
          ),
          GoRoute(path: 'w', redirect: (state) => '/'),
          GoRoute(
            path: 'w/:workspaceId',
            name: AppRoute.workspace.name,
            builder: (_, state) {
              final workspaceId = state.params['workspaceId']!;
              final menuName = state.queryParams['menu'];
              final menu = WorkspaceMenu.values.firstWhereOrNull(
                (menu) => menu.name == menuName,
              );
              final taskStateName = state.queryParams['state'];
              final taskState = TaskState.tabs.firstWhereOrNull(
                (taskState) => taskState.name == taskStateName,
              );
              return WorkspaceScreen(
                workspaceId: workspaceId,
                menu: menu,
                taskState: taskState,
              );
            },
            routes: [
              GoRoute(
                path: 't',
                redirect: (state) {
                  final path = state.location;
                  return path.substring(0, path.length - 2);
                },
              ),
              GoRoute(
                path: 't/:taskId',
                name: AppRoute.task.name,
                pageBuilder: (_, state) {
                  final taskId = state.params['taskId']!;
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: TaskScreen(taskId: taskId),
                  );
                },
              ),
              GoRoute(
                path: 'preferences',
                name: AppRoute.workspacePreferences.name,
                pageBuilder: (_, state) {
                  final workspaceId = state.params['workspaceId']!;
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: WorkspacePreferencesScreen(workspaceId: workspaceId),
                  );
                },
              ),
              GoRoute(
                path: 'archive',
                name: AppRoute.workspaceArchive.name,
                pageBuilder: (_, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: const ArchivedTasksScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => const NotFoundScreen(),
  );
});
