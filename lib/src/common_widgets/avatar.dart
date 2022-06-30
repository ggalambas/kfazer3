import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class Avatar extends StatelessWidget {
  final double diameter;
  final BoxShape shape;
  final ImageProvider? foregroundImage;
  final String? text;

  const Avatar({
    super.key,
    double radius = 16,
    this.shape = BoxShape.circle,
    this.foregroundImage,
    this.text,
  }) : diameter = radius * 2;

  factory Avatar.fromUser(AppUser? user, {double radius = 16}) => Avatar(
        text: user?.name,
        radius: radius,
        foregroundImage:
            user?.photoUrl == null ? null : NetworkImage(user!.photoUrl!),
      );

  factory Avatar.fromWorkspace(Workspace workspace, {double radius = 20}) =>
      Avatar(
        text: workspace.title,
        radius: radius,
        shape: BoxShape.rectangle,
        foregroundImage: workspace.photoUrl == null
            ? null
            : NetworkImage(workspace.photoUrl!),
      );

  bool get _isTextEmpty => text == null || text!.isEmpty;

  BorderRadiusGeometry? get borderRadius => shape == BoxShape.rectangle
      ? BorderRadius.circular(diameter * 0.3)
      : null;

  Color backgroundColor(BuildContext context) {
    if (foregroundImage != null || _isTextEmpty) {
      return context.colorScheme.primaryContainer;
    }
    final textCode = text!.codeUnits.sum;
    final colors = Colors.primaries
        .map((color) => ColorScheme.fromSeed(
              seedColor: color,
              brightness: context.theme.brightness,
            ).primaryContainer)
        .toList();
    return colors[textCode % colors.length];
  }

  String initials() {
    final notEmptyText = _isTextEmpty ? '?' : text!;
    var parts = notEmptyText.trim().split(' ').map((p) => p.substring(0, 1));
    if (parts.length > 2) parts = [parts.first, parts.last];
    return parts.join('').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: borderRadius,
        color: backgroundColor(context),
      ),
      foregroundDecoration: foregroundImage == null
          ? null
          : BoxDecoration(
              shape: shape,
              borderRadius: borderRadius,
              image: DecorationImage(
                image: foregroundImage!,
                fit: BoxFit.cover,
              ),
            ),
      child: Center(
        child: Text(
          initials(),
          style: context.textTheme.labelLarge,
        ),
      ),
    );
    return _isTextEmpty ? avatar : Tooltip(message: text, child: avatar);
  }
}
