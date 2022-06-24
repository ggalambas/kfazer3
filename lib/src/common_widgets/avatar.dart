import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';
import 'package:kfazer3/src/features/workspace/domain/workspace.dart';

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

  factory Avatar.fromUser(AppUser user, {double radius = 16}) => Avatar(
        text: user.name,
        radius: radius,
        foregroundImage:
            user.photoUrl == null ? null : NetworkImage(user.photoUrl!),
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

  final _disabledColor = Colors.black26;
  final List<Color> _colors = const [
    Color(0xFFFFA93F),
    Color(0xFF6FFF52),
    Color(0xFFFF4747),
    Color(0xFF664AFF),
    Color(0xFF37EEFF),
    Color(0xFFFF5AFF),
    Color(0xFF3B86FF),
  ];

  BorderRadiusGeometry? get borderRadius => shape == BoxShape.rectangle
      ? BorderRadius.circular(diameter * 0.3)
      : null;

  Color backgroundColor() {
    if (foregroundImage != null) return Colors.transparent;
    if (text == null || text!.isEmpty) return _disabledColor;
    final textCode = text!.codeUnits.sum;
    return _colors[textCode % _colors.length];
  }

  String initials() {
    final notEmptyText = text == null || text!.isEmpty ? '?' : text!;
    var parts = notEmptyText.trim().split(' ').map((p) => p.substring(0, 1));
    if (parts.length > 2) parts = [parts.first, parts.last];
    return parts.join('').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: text,
      child: Container(
        height: diameter,
        width: diameter,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: borderRadius,
          color: backgroundColor(),
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
            style: theme.textTheme.titleMedium!.copyWith(
              color: Colors.white,
              fontSize: diameter * 0.45,
            ),
          ),
        ),
      ),
    );
  }
}
