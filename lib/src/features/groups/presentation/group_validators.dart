import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

mixin GroupValidators {
  List<StringValidator> nameSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidNameEmpty),
      ];

  List<StringValidator> descriptionSubmitValidators(BuildContext context) => [];
}

extension GroupValidatorsText on GroupValidators {
  String? nameErrorText(BuildContext context, String name) =>
      nameSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;

  String? descriptionErrorText(BuildContext context, String name) =>
      descriptionSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
