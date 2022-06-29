import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

/// Loading button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingElevatedButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingElevatedButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: context.colorScheme.primaryContainer,
      ),
      onPressed: onPressed,
      child: isLoading ? const CircularProgressIndicator() : Text(text),
    );
  }
}

/// Loading button based on [OutlinedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingOutlinedButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingOutlinedButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: isLoading ? const CircularProgressIndicator() : Text(text),
    );
  }
}
