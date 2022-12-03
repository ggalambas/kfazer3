import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/localization_context.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.loc.performance));
  }
}
