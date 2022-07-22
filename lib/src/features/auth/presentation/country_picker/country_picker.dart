import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'country_picker_dialog.dart';

/// Text field prefix equivalent of [CountryPicker]
class CountryPickerPrefix extends StatelessWidget {
  final Country selected;
  final List<Country> countries;
  final ValueChanged<Country> onChanged;

  const CountryPickerPrefix({
    super.key,
    required this.selected,
    required this.countries,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: kSpace),
      child: CountryPicker(
        selected: selected,
        countries: countries,
        onChanged: onChanged,
      ),
    );
  }
}

class CountryPicker extends StatelessWidget {
  final Country selected;
  final List<Country> countries;
  final ValueChanged<Country> onChanged;

  const CountryPicker({
    super.key,
    required this.selected,
    required this.countries,
    required this.onChanged,
  });

  Future<Country?> showCountryDialog(BuildContext context) =>
      showDialog<Country>(
        context: context,
        builder: (context) => CountryPickerDialog(countries: countries),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const StadiumBorder(),
      onTap: () async {
        final country = await showCountryDialog(context);
        if (country != null) onChanged(selected);
      },
      child: Padding(
        padding: EdgeInsets.only(right: kSpace / 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.expand_more,
              size: kSmallIconSize,
            ),
            Text(
              selected.phoneCode,
              // TextField default style
              style: context.textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
