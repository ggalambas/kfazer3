import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';

import 'http_country_repository.dart';

final countryRepositoryProvider = Provider<CountryRepository>(
  (ref) => HttpCountryRepository(),
);

abstract class CountryRepository {
  Future<List<Country>> fetchCountryList();
}

final countryListFutureProvider = FutureProvider<List<Country>>((ref) async {
  final countryRepository = ref.watch(countryRepositoryProvider);
  final countryList = await countryRepository.fetchCountryList();
  return countryList;
});
