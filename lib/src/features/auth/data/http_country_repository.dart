import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

import 'country_repository.dart';

class HttpCountryRepository implements CountryRepository {
  @override
  Future<List<Country>> fetchCountryList() async {
    final response = await http.get(
      Uri.parse(
        'https://restcountries.com/v2/'
        'all?fields=name,alpha2Code,callingCodes,flags',
      ),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      return compute(_decodeCountryList, response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception
      throw Exception('Failed to load list of countries'.hardcoded);
    }
  }

  List<Country> _decodeCountryList(String responseBody) {
    try {
      final parsedJson = jsonDecode(responseBody) as List;
      // Duplicate countries with more than 1 calling code
      return parsedJson.expand((json) {
        final callingCodes = (json['callingCodes'] as List).cast<String>();
        return callingCodes
            .map((code) => Country.fromJson(json..['callingCode'] = code))
            .toList();
      }).toList();
    } catch (_) {
      throw Exception('Failed to load list of countries'.hardcoded);
    }
  }
}
