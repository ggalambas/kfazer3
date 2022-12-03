import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

mixin GroupValidators {
  List<StringValidator> titleSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidTitleEmpty),
      ];

  List<StringValidator> descriptionSubmitValidators(BuildContext context) => [];
}

extension GroupValidatorsText on GroupValidators {
  String? titleErrorText(BuildContext context, String name) =>
      titleSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;

  String? descriptionErrorText(BuildContext context, String name) =>
      descriptionSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
