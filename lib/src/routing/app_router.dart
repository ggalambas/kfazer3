import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/features/notifications/presentation/notifications_screen.dart';
import 'package:kfazer3/src/features/settings/presentation/settings_screen.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/tasks/presentation/archive/archived_tasks_screen.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/task_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/preferences/motivational_messages_screen.dart';
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
  workspaceSetup, //! fullscreenDialog
  workspace,
  workspaceMenu,
  // TODO Rethink fullscreen dialogs
  workspacePreferences, //! fullscreenDialog
  motivationalMessages, //! fullscreenDialog
  workspaceArchive, //! fullscreenDialog
  task, //! fullscreenDialog
  notifications, //! fullscreenDialog
  settings, //! fullscreenDialog
  account,
}

// TODO go throught every go and push
final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (state) {
      //TODO uncomment to make login available
      // final isLoggedIn = authRepository.currentUser != null;
      // if (isLoggedIn) {
      //   if (state.location.contains('/signIn')) return '/';
      // } else {
      //   if (!state.location.contains('/signIn')) return '/signIn';
      // }
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
        redirect: (state) {
          final pageName = state.params['page']!;
          final phoneNumber =
              ref.read(signInControllerProvider.notifier).phoneNumber;
          final resetLoginFlow =
              pageName != SignInPage.phone.name && phoneNumber == null;
          if (resetLoginFlow) return '/signIn';
          return null;
        },
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
            routes: [
              GoRoute(
                path: 'account',
                name: AppRoute.account.name,
                builder: (_, state) => const AccountScreen(),
              ),
            ],
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
                path: 'motivational-messages',
                name: AppRoute.motivationalMessages.name,
                pageBuilder: (_, state) {
                  final workspaceId = state.params['workspaceId']!;
                  return MaterialPage(
                    key: state.pageKey,
                    fullscreenDialog: true,
                    child: MotivationalMessagesScreen(workspaceId: workspaceId),
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
