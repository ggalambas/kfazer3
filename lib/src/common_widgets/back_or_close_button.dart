import 'package:flutter/material.dart';

/// Checks the parentRoute to know if it implies a back/close button
/// and returns a BackButton or a CloseButton
Widget? backOrCloseButton(BuildContext context) {
  final parentRoute = ModalRoute.of(context);
  final canPop = parentRoute?.canPop ?? false;
  final impliesDismissal = parentRoute?.impliesAppBarDismissal ?? false;
  final useCloseButton =
      parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
  if (!canPop && !impliesDismissal) return null;
  return useCloseButton ? const CloseButton() : const BackButton();
}
