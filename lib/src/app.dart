import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/theme/app_theme.dart';

import 'routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final locale = ref.watch(languageStateProvider).locale;
    final themeMode = ref.watch(themeModeStateProvider).mode;
    final lightTheme = ref.watch(themeProvider(Brightness.light));
    final darkTheme = ref.watch(themeProvider(Brightness.dark));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      onGenerateTitle: (context) => context.loc.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      routerConfig: goRouter,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      scrollBehavior:
          ScrollConfiguration.of(context).copyWith(scrollbars: false),
    );
  }
}
