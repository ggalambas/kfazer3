import 'package:flutter/material.dart';

import 'routing/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData theme(Brightness brightness) {
    var theme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.indigo,
      brightness: brightness,
      bottomSheetTheme: const BottomSheetThemeData(
        // Default M3 Dialog properties
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.0),
            topRight: Radius.circular(28.0),
          ),
        ),
      ),
    );
    return theme.copyWith(
      popupMenuTheme: PopupMenuThemeData(
        elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: ElevationOverlay.applySurfaceTint(
          theme.backgroundColor,
          theme.colorScheme.surfaceTint,
          6.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: goRouter.routerDelegate,
      routeInformationParser: goRouter.routeInformationParser,
      restorationScopeId: 'app',
      title: 'KFazer',
      theme: theme(Brightness.light),
      darkTheme: theme(Brightness.dark),
      themeMode: ThemeMode.system,
    );
  }
}
