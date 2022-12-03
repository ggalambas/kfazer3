import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';

class PhoneCodeController extends ValueNotifier<String?> {
  PhoneCodeController({String code = ''}) : super(code);

  String get code => value!;
  set code(String country) => value = country;

  void setCodeFromLocale(Locale locale, List<Country> countryList) =>
      code = _getCodeFromLocale(locale, countryList);

  factory PhoneCodeController.fromLocale(
    Locale locale,
    List<Country> countryList,
  ) =>
      PhoneCodeController(code: _getCodeFromLocale(locale, countryList));

  static String _getCodeFromLocale(Locale locale, List<Country> countryList) {
    final country = countryList.firstWhere(
      (country) => country.code == locale.countryCode,
      orElse: () => countryList.first,
    );
    return country.phoneCode;
  }
}
