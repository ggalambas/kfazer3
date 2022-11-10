import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'country_picker_dialog.dart';

//TODO create a file for this
class PhoneCodeController extends ValueNotifier<String?> {
  PhoneCodeController({required String code}) : super(code);

  String get code => value!;
  set code(String country) => value = country;

  factory PhoneCodeController.fromLocale(
    Locale locale,
    List<Country> countryList,
  ) {
    final country = countryList.firstWhere(
      (country) => country.code == locale.countryCode,
      orElse: () => countryList.first,
    );
    return PhoneCodeController(code: country.phoneCode);
  }
}

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

  Future<Country?> showCountryPicker(BuildContext context) =>
      showDialog<Country>(
        context: context,
        builder: (context) => const CountryPickerDialog(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, code, _) {
          return InkWell(
            customBorder: const StadiumBorder(),
            onTap: () async {
              final country = await showCountryPicker(context);
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
