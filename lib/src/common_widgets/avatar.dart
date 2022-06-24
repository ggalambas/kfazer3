import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/auth/domain/app_user.dart';

class Avatar extends StatelessWidget {
  static const kRadius = 16.0;

  final String name;
  final String? photoUrl;
  const Avatar({super.key, required this.name, this.photoUrl});

  factory Avatar.fromUser(AppUser user) =>
      Avatar(name: user.name, photoUrl: user.photoUrl);

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

  List<String> get nameParts =>
      name.trim().split(' ').map((p) => p.substring(0, 1)).toList();

  Color get backgroundColor {
    if (name.isEmpty) return _disabledColor;
    final textCode = nameParts.map((c) => c.codeUnitAt(0)).sum;
    return _colors[textCode % _colors.length];
  }

  String get initials {
    if (name.isEmpty) return '?';
    var copy = nameParts;
    if (copy.length > 2) copy = [copy.first, copy.last];
    return copy.join('').toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: name,
      child: photoUrl == null
          ? CircleAvatar(
              radius: kRadius,
              backgroundColor: backgroundColor,
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: kRadius * 0.9,
                  color: Colors.white,
                ),
              ),
            )
          : CircleAvatar(
              radius: kRadius,
              backgroundColor: Colors.transparent,
              foregroundImage: NetworkImage(photoUrl!),
            ),
    );
  }
}
