import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/circular_progress_icon.dart';

/// Loading button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param child - child to display on the button, usually a Text widget.
/// @param loading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingElevatedButton extends StatelessWidget {
  final Widget child;
  final bool loading;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  const LoadingElevatedButton({
    super.key,
    required this.child,
    this.loading = false,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: loading ? null : onPressed,
      child: loading ? const CircularProgressIcon() : child,
    );
  }
}

/// Loading button based on [OutlinedButton].
/// Useful for CTAs in the app.
/// @param child - child to display on the button, usually a Text widget.
/// @param loading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingOutlinedButton extends StatelessWidget {
  final Widget child;
  final bool loading;
  final VoidCallback? onPressed;

  const LoadingOutlinedButton({
    super.key,
    required this.child,
    this.loading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: loading ? null : onPressed,
      child: loading ? const CircularProgressIcon() : child,
    );
  }
}

/// Loading button based on [TextButton].
/// Useful for CTAs in the app.
/// @param child - child to display on the button, usually a Text widget.
/// @param loading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingTextButton extends StatelessWidget {
  final Widget child;
  final bool loading;
  final VoidCallback? onPressed;

  const LoadingTextButton({
    super.key,
    required this.child,
    this.loading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading ? null : onPressed,
      child: loading ? const CircularProgressIcon() : child,
    );
  }
}

/// Loading button based on [IconButton].
/// Useful for CTAs in the app.
/// @param child - child to display on the button, usually an Icon widget.
/// @param loading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class LoadingIconButton extends StatelessWidget {
  final String? tooltip;
  final double? iconSize;
  final Widget icon;
  final bool loading;
  final VoidCallback? onPressed;

  const LoadingIconButton({
    super.key,
    required this.icon,
    this.loading = false,
    this.onPressed,
    this.iconSize,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      iconSize: iconSize,
      onPressed: loading ? null : onPressed,
      icon: loading ? const CircularProgressIcon() : icon,
    );
  }
}
