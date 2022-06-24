import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/primary_button.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

class ProfileCreationPage extends StatelessWidget {
  const ProfileCreationPage({super.key});

  void goToHome(BuildContext context) => context.goNamed(AppRoute.home.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSpace * 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('name input'.hardcoded),
            Space(4),
            PrimaryButton(
              onPressed: () => goToHome(context),
              text: 'Create profile'.hardcoded,
            )
          ],
        ),
      ),
    );
  }
}
