import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';

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
