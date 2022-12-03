import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/data/country_repository.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/localization/localization_context.dart';
import 'package:smart_space/smart_space.dart';

import 'country_tile.dart';

class CountryPickerDialog extends StatefulWidget {
  const CountryPickerDialog({super.key});

  @override
  State<CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: searchController,
      builder: (context, _, __) {
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          titlePadding: EdgeInsets.only(top: kSpace * 2),
          contentPadding: EdgeInsets.zero,
          title: CountrySearchField(controller: searchController),
          content: SizedBox(
            width: Breakpoint.tablet,
            child: CountryListView(
              query: searchController.text.trim().toLowerCase(),
            ),
          ),
        );
      },
    );
  }
}

class CountrySearchField extends StatelessWidget {
  final TextEditingController controller;
  const CountrySearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kSpace * 2),
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: context.loc.searchHint,
            suffixIcon: controller.text.isEmpty
                ? const IconButton(
                    iconSize: kSmallIconSize,
                    onPressed: null,
                    icon: Icon(Icons.search_outlined),
                  )
                : IconButton(
                    tooltip: context.loc.clear,
                    iconSize: kSmallIconSize,
                    onPressed: () => controller.text = '',
                    icon: const Icon(Icons.clear_outlined),
                  ),
          ),
        ),
      ),
    );
  }
}

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
      //TODO check if we prefer with or without the shimmer
      loading: ListView.builder(
        padding: EdgeInsets.only(top: kSpace),
        itemBuilder: (context, i) => const LoadingCountryTile(),
      ),
      data: (countryList) {
        final countries = filteredCountries(countryList);
        return ListView.builder(
          padding: EdgeInsets.only(top: kSpace),
          itemCount: countries.length,
          itemBuilder: (context, i) => CountryTile(countries[i]),
        );
      },
    );
  }
}
