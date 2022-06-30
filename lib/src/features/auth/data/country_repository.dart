import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kfazer3/src/features/auth/domain/country.dart';

final countryRepositoryProvider = Provider<CountryRepository>(
  (ref) => HttpCountryRepository(),
);

final countryListFutureProvider = FutureProvider.autoDispose<List<Country>>(
  (ref) async {
    final countryRepository = ref.watch(countryRepositoryProvider);
    final countryList = await countryRepository.fetchCountryList();
    ref.keepAlive();
    return countryList;
  },
);

abstract class CountryRepository {
  Future<List<Country>> fetchCountryList();
}

class HttpCountryRepository implements CountryRepository {
  @override
  Future<List<Country>> fetchCountryList() async {
    //!
    return [
      const Country(
        code: 'PT',
        name: 'Portugal',
        phoneCode: 351,
        flagUrl: 'https://flagcdn.com/w320/pt.png',
      )
    ];
    //TODO check for certificate
    final response = await http.get(
      Uri.parse(
        'https://restcountries.com/v2/all?fields=name,alpha2Code,callingCodes,flags',
      ),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      return compute(_decodeCountryList, response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception
      throw Exception('Failed to load list of countries');
    }
  }

  List<Country> _decodeCountryList(String responseBody) {
    final parsedJson = jsonDecode(responseBody) as List;
    // Duplicate countries with more than 1 calling code
    return parsedJson.expand((json) {
      final callingCodes = (json['callingCodes'] as List).cast<String>();
      return callingCodes
          .map((code) => Country.fromJson(json..['callingCode'] = code))
          .toList();
    }).toList();
  }
}
