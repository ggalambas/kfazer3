import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:smart_space/smart_space.dart';

import 'country_list_view.dart';
import 'country_search_field.dart';

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
