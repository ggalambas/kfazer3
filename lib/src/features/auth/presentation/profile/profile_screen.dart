import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'.hardcoded)),
      body: Center(child: Text('Profile'.hardcoded)),
    );
  }
}
