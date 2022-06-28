import 'package:flutter/material.dart';

import 'phone_number_sign_in_page.dart';
import 'phone_number_verification_page.dart';
import 'profile_creation_page.dart';

/// The three sub-routes that are presented as part of the sign in flow.
enum SignInSubRoute { phoneNumber, verification, profile }

/// This is the root widget of the sign in flow, which is composed of 3 pages:
/// 1. Phone number sign in page
/// 2. Phone number verification page
/// 3. Profile creation page
///
///! The logic for the entire flow is implemented in the [SignInScreenController],
/// while UI updates are handled by a [PageController].
class SignInScreen extends StatefulWidget {
  final SignInSubRoute subRoute;
  const SignInScreen({super.key, required this.subRoute});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final controller = PageController(initialPage: widget.subRoute.index);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SignInScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // perform a nice scroll animation to reveal the next page
    if (controller.hasClients && controller.position.hasViewportDimension) {
      controller.animateToPage(
        widget.subRoute.index,
        duration: kTabScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return a Scaffold with a PageView containing the 3 pages.
    // This allows for a nice scroll animation when switching between pages.
    // Note: only the currently active page will be visible.
    return Scaffold(
      body: PageView(
        // disable swiping between pages
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          PhoneNumberSignInPage(),
          PhoneNumberVerificationPage(),
          ProfileCreationPage(),
        ],
      ),
    );
  }
}
