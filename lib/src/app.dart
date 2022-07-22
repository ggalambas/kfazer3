import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/theme/app_theme.dart';

import 'routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO check if new goRouter version no longer has bugs
    final goRouter = ref.watch(goRouterProvider);
    final lightTheme = ref.watch(themeProvider(Brightness.light));
    final darkTheme = ref.watch(themeProvider(Brightness.dark));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      restorationScopeId: 'app',
      title: 'KFazer',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
