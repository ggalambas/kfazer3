import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/localization_context.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.loc.team));
  }
}
