import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in_flow/sign_in_screen.dart';
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
  signInSubRoute,
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

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/signIn',
      name: AppRoute.signIn.name,
      redirect: (state) =>
          '${state.location}/${SignInSubRoute.values.first.name}',
    ),
    GoRoute(
      path: '/signIn/:subRoute',
      name: AppRoute.signInSubRoute.name,
      builder: (_, state) {
        final subRouteName = state.params['subRoute']!;
        final subRoute = SignInSubRoute.values.firstWhere(
          (subRoute) => subRoute.name == subRouteName,
          orElse: () => SignInSubRoute.values.first,
        );
        return SignInScreen(subRoute: subRoute);
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
              menu: menu ?? WorkspaceMenu.main,
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
                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const WorkspacePreferencesScreen(),
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
