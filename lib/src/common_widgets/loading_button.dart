import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

/// Loading button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param child - child to display on the button, usually a Text widget.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingElevatedButton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingElevatedButton({
    super.key,
    required this.child,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: context.colorScheme.primaryContainer,
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: kSmallIconSize,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : child,
    );
  }
}

/// Loading button based on [OutlinedButton].
/// Useful for CTAs in the app.
/// @param child - child to display on the button, usually a Text widget.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingOutlinedButton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingOutlinedButton({
    super.key,
    required this.child,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: kSmallIconSize,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : child,
    );
  }
}

/// Loading button based on [TextButton].
/// Useful for CTAs in the app.
/// @param child - child to display on the button, usually a Text widget.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingTextButton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingTextButton({
    super.key,
    required this.child,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox.square(
              dimension: kSmallIconSize,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : child,
    );
  }
}