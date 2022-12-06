import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

mixin MotivationValidators {
  List<StringValidator> messageSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidMessageEmpty),
      ];
}

extension MotivationValidatorsText on MotivationValidators {
  String? messageErrorText(BuildContext context, String name) =>
      messageSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
