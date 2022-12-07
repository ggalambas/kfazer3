import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'country_picker_dialog.dart';
import 'phone_code_controller.dart';

/// Text field prefix equivalent of [PhoneCodeDropdownButton]
class PhoneCodeDropdownPrefix extends StatelessWidget {
  final PhoneCodeController controller;
  const PhoneCodeDropdownPrefix({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: kSpace),
      child: PhoneCodeDropdownButton(controller: controller),
    );
  }
}

class PhoneCodeDropdownButton extends ConsumerWidget {
  final PhoneCodeController controller;
  const PhoneCodeDropdownButton({super.key, required this.controller});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, code, _) {
          return InkWell(
            customBorder: const StadiumBorder(),
            onTap: () async {
              final country = await showCountryPickerDialog(context);
              if (country != null) controller.code = country.phoneCode;
            },
            child: Padding(
              padding: EdgeInsets.only(right: kSpace / 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.expand_more,
                    size: kSmallIconSize,
                  ),
                  Text(
                    controller.code,
                    // TextField default style
                    style: context.textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
