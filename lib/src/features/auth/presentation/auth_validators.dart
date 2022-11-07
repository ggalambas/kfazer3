import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

mixin AuthValidators {
  List<StringValidator> phoneSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidPhoneNumberEmpty),
        NumberStringValidator(context.loc.invalidPhoneNumberOnlyNumbers),
      ];

  List<StringValidator> codeSubmitValidators(BuildContext context) => [
        ExactLengthStringValidator(
          context.loc.invalidCodeLength(kCodeLength),
          length: kCodeLength,
        ),
      ];

  List<StringValidator> nameSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidNameEmpty),
      ];
}

extension AuthValidatorsText on AuthValidators {
  String? phoneNumberErrorText(BuildContext context, String phoneNumber) =>
      phoneSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(phoneNumber))
          ?.errorText;

  String? codeErrorText(BuildContext context, String code) =>
      codeSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(code))
          ?.errorText;

  String? nameErrorText(BuildContext context, String name) =>
      nameSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
