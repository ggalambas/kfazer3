import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/utils/string_validator.dart';

mixin QuoteValidators {
  List<StringValidator> quoteSubmitValidators(BuildContext context) => [
        NonEmptyStringValidator(context.loc.invalidQuoteEmpty),
      ];
}

extension QuoteValidatorsText on QuoteValidators {
  String? quoteErrorText(BuildContext context, String name) =>
      quoteSubmitValidators(context)
          .firstWhereOrNull((validator) => !validator.isValid(name))
          ?.errorText;
}
