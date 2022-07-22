import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = Provider.family<ThemeData, Brightness>((ref, brightness) {
  final theme = ThemeData(
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.padded,
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
});
