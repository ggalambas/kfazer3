abstract class StringValidator {
  String get errorText;
  bool isValid(String value);
}

class NonEmptyStringValidator extends StringValidator {
  @override
  final String errorText;
  NonEmptyStringValidator(this.errorText);

  @override
  bool isValid(String value) => value.isNotEmpty;
}

class ExactLengthStringValidator extends StringValidator {
  @override
  final String errorText;
  final int length;
  ExactLengthStringValidator(this.errorText, {required this.length});

  @override
  bool isValid(String value) => value.length == length;
}

class NumberStringValidator extends StringValidator {
  @override
  final String errorText;
  NumberStringValidator(this.errorText);

  @override
  bool isValid(String value) => int.tryParse(value) != null;
}
