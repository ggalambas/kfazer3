import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class Avatar extends StatelessWidget {
  final double diameter;
  final BoxShape shape;
  final ImageProvider? foregroundImage;

  final String? text;
  late final String? initials;
  final IconData icon;

  /// A shape that represents an entity.
  /// Typically used with an image, or, in the absence of such an image, a text initials.
  /// If [foregroundImage] fails then [initials] is used. If [initials] fails too, [icon] is used.
  /// [text] is used to generate [initials] and be displayed in a tooltip
  Avatar({
    super.key,
    double radius = 16,
    this.shape = BoxShape.circle,
    this.foregroundImage,
    this.text,
    this.icon = Icons.person,
  }) : diameter = radius * 2 {
    initials = _generateInitials(text);
  }

  String? _generateInitials(String? text) {
    if (text == null || text.isEmpty) return null;
    var parts = text
        .trim()
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p.substring(0, 1));
    if (parts.length > 2) parts = [parts.first, parts.last];
    return parts.join('').toUpperCase();
  }

  double get _fontSize => 0.45 * diameter;
  BorderRadiusGeometry? get _borderRadius => shape == BoxShape.rectangle
      ? BorderRadius.circular(diameter * 0.3)
      : null;

  Color _generateBackgroundColor(BuildContext context) {
    // use the primaryContainer color when:
    // - there's a foreground image (to deal with opacity)
    // - there's no initials (icon is displayed)
    if (foregroundImage != null || initials == null) {
      return context.colorScheme.primaryContainer;
    }
    final textCode = initials!.codeUnits.sum;
    final colors = Colors.primaries
        .map((color) => ColorScheme.fromSeed(
              seedColor: color,
              brightness: context.theme.brightness,
            ).primaryContainer)
        .toList();
    return colors[textCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: _borderRadius,
        color: _generateBackgroundColor(context),
      ),
      foregroundDecoration: foregroundImage == null
          ? null
          : BoxDecoration(
              shape: shape,
              borderRadius: _borderRadius,
              image: DecorationImage(
                image: foregroundImage!,
                fit: BoxFit.cover,
              ),
            ),
      child: foregroundImage == null
          ? Center(
              child: initials == null
                  ? Icon(icon, size: _fontSize)
                  : Text(
                      initials!,
                      style: context.textTheme.labelLarge!.copyWith(
                        fontSize: _fontSize,
                      ),
                    ),
            )
          : null,
    );
    if (initials == null) return avatar;
    return Tooltip(message: text, child: avatar);
  }
}
