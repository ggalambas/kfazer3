import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/avatar.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:smart_space/smart_space.dart';

class CountryPickerDialog extends StatefulWidget {
  final List<Country> countries;
  const CountryPickerDialog({super.key, required this.countries});

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

  List<Country> filterCountries() {
    final query = searchController.text.trim().toLowerCase();
    return widget.countries
        .where((country) =>
            country.name.toLowerCase().contains(query) ||
            country.code.toLowerCase().contains(query) ||
            country.phoneCode.toString().toLowerCase().contains(query))
        .toList();
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
            content: CountryListView(countries: filterCountries()),
          );
        });
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
            hintText: 'Search...'.hardcoded,
            suffixIcon: controller.text.isEmpty
                ? const IconButton(
                    iconSize: kSmallIconSize,
                    onPressed: null,
                    icon: Icon(Icons.search_outlined),
                  )
                : IconButton(
                    tooltip: 'Clear'.hardcoded,
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

//TODO Throwing a constraints error in the web
class CountryListView extends StatelessWidget {
  final List<Country> countries;
  const CountryListView({super.key, required this.countries});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: kSpace),
      children: [
        for (final country in countries)
          ListTile(
            dense: true,
            leading: Avatar(
              text: country.code.split('').join(' '),
              radius: 12,
              foregroundImage: NetworkImage(country.flagUrl, scale: 0.2),
            ),
            title: Text(country.name),
            trailing: Text(country.phoneCode),
            onTap: () => Navigator.pop(context, country),
          ),
      ],
    );
  }
}
