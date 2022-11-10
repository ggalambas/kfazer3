import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_details_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/account/account_edit_screen.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_controller.dart';
import 'package:kfazer3/src/features/auth/presentation/sign_in/sign_in_screen.dart';
import 'package:kfazer3/src/features/notifications/presentation/notification_list_screen.dart';
import 'package:kfazer3/src/features/settings/presentation/settings_screen.dart';
import 'package:kfazer3/src/features/tasks/domain/task_state.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_list/archived_tasks_screen.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/task_activity_screen.dart';
import 'package:kfazer3/src/features/tasks/presentation/task_screen/task_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_details_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/motivation/motivation_edit_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/preferences/workspace_preferences_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_details/workspace_details_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_details/workspace_edit_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_list/workspace_list_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_screen/workspace_screen.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/workspace_setup_screen.dart';
import 'package:kfazer3/src/routing/not_found_screen.dart';

import 'refresh_stream.dart';

enum AppRoute {
  signIn,
  signInPage,

  home,
  workspaceSetup, //! fullscreenDialog
  workspaceSetupPage,

  group,
  workspaceMenu,
  workspacePreferences, //! fullscreenDialog
  workspaceDetails,
  motivation,
  workspaceArchive, //! fullscreenDialog

  task,
  taskActivity, //! fullscreenDialog

  notifications, //! fullscreenDialog
  settings, //! fullscreenDialog
  accountDetails,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location.contains('/sign-in')) return '/';
      } else {
        if (!state.location.contains('/sign-in')) return '/sign-in';
      }
      return null;
    },
    refreshListenable: RefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/sign-in',
        name: AppRoute.signIn.name,
        redirect: (context, state) =>
            '${state.location}/${SignInPage.values.first.name}',
      ),
      GoRoute(
        path: '/sign-in/:page',
        name: AppRoute.signInPage.name,
        redirect: (context, state) {
          final pageName = state.params['page']!;
          final payload = ref.read(signInPayloadProvider);
          if (pageName == SignInPage.verification.name) {
            if (payload.phoneNumber == null) return '/signIn';
          } else if (pageName == SignInPage.account.name) {
            if (payload.phoneNumber == null) return '/signIn';
            if (!payload.isCodeValid) {
              return '/signIn/${SignInPage.verification.name}';
            }
          }
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
              child: const NotificationsListScreen(),
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
                name: AppRoute.accountDetails.name,
                builder: (_, state) {
                  final editingParam = state.queryParams['editing'];
                  final editing = editingParam == 'true';
                  return editing
                      ? const AccountEditScreen()
                      : const AccountDetailsScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: 'setup',
            name: AppRoute.workspaceSetup.name,
            redirect: (context, state) =>
                '${state.location}/${WorkspaceSetupPage.values.first.name}',
          ),
          GoRoute(
            path: 'setup/:page',
            name: AppRoute.workspaceSetupPage.name,
            redirect: (context, state) {
              //! workspace setup auto reset
              // final pageName = state.params['page']!;
              // final workspaceId = ref
              //     .read(workspaceSetupControllerProvider.notifier)
              //     .workspaceId;
              // final resetSetupFlow =
              //     pageName != WorkspaceSetupPage.details.name &&
              //         workspaceId == null;
              // if (resetSetupFlow) return '/setup';
              return null;
            },
            pageBuilder: (_, state) {
              final pageName = state.params['page']!;
              final page = WorkspaceSetupPage.values.firstWhere(
                (page) => page.name == pageName,
                orElse: () => WorkspaceSetupPage.values.first,
              );
              return MaterialPage(
                key: state.pageKey,
                fullscreenDialog: page == WorkspaceSetupPage.values.first,
                child: WorkspaceSetupScreen(page: page),
              );
            },
          ),
          GoRoute(path: 'w', redirect: (context, state) => '/'),
          GoRoute(
            path: 'w/:groupId',
            name: AppRoute.group.name,
            builder: (_, state) {
              final groupId = state.params['groupId']!;
              final menuName = state.queryParams['menu'];
              final menu = WorkspaceMenu.values.firstWhereOrNull(
                (menu) => menu.name == menuName,
              );
              final taskStateName = state.queryParams['state'];
              final taskState = TaskState.tabs.firstWhereOrNull(
                (taskState) => taskState.name == taskStateName,
              );
              return WorkspaceScreen(
                workspaceId: groupId,
                menu: menu,
                taskState: taskState,
              );
            },
            routes: [
              GoRoute(
                path: 't',
                redirect: (context, state) {
                  final path = state.location;
                  final tIndex = path.lastIndexOf('t');
                  return path.substring(0, tIndex);
                },
              ),
              GoRoute(
                path: 't/:taskId',
                name: AppRoute.task.name,
                builder: (_, state) {
                  final workspaceId = state.params['workspaceId']!;
                  final taskId = state.params['taskId']!;
                  return TaskScreen(
                    workspaceId: workspaceId,
                    taskId: taskId,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'activity',
                    name: AppRoute.taskActivity.name,
                    pageBuilder: (_, state) {
                      final taskId = state.params['taskId']!;
                      return MaterialPage(
                        key: state.pageKey,
                        fullscreenDialog: true,
                        child: TaskActivityScreen(taskId: taskId),
                      );
                    },
                  ),
                ],
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
                routes: [
                  GoRoute(
                    path: 'details',
                    name: AppRoute.workspaceDetails.name,
                    builder: (_, state) {
                      final workspaceId = state.params['workspaceId']!;
                      final editingParam = state.queryParams['editing'];
                      final editing = editingParam == 'true';
                      return editing
                          ? WorkspaceEditScreen(workspaceId: workspaceId)
                          : WorkspaceDetailsScreen(workspaceId: workspaceId);
                    },
                  ),
                  GoRoute(
                    path: 'motivational-messages',
                    name: AppRoute.motivation.name,
                    builder: (_, state) {
                      final workspaceId = state.params['workspaceId']!;
                      final editingParam = state.queryParams['editing'];
                      final editing = editingParam == 'true';
                      return editing
                          ? MotivationEditScreen(workspaceId: workspaceId)
                          : MotivationDetailsScreen(workspaceId: workspaceId);
                    },
                  ),
                ],
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
