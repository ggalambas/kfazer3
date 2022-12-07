import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:smart_space/smart_space.dart';

import 'country_tile.dart';

class CountryListView extends ConsumerWidget {
  final String query;
  const CountryListView({super.key, this.query = ''});

  List<Country> filteredCountries(List<Country> countryList) {
    return countryList
        .where((country) =>
            country.name.toLowerCase().contains(query) ||
            country.code.toLowerCase().contains(query) ||
            country.phoneCode.toString().toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryListValue = ref.watch(countryListFutureProvider);
    return AsyncValueWidget<List<Country>>(
      value: countryListValue,
      loading: ListView.builder(
        padding: EdgeInsets.only(top: kSpace),
        itemBuilder: (context, i) => const LoadingCountryTile(),
      ),
      data: (countryList) {
        final countries = filteredCountries(countryList);
        return ListView.builder(
          padding: EdgeInsets.only(top: kSpace),
          itemCount: countries.length,
          itemBuilder: (context, i) => const LoadingCountryTile(),
          // CountryTile(countries[i]),
        );
      },
    );
  }
}
