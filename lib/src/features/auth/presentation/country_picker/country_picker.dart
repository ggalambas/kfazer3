import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/features/auth/presentation/country_picker/country_picker_dialog.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class CountryPicker extends StatefulWidget {
  final List<Country> countries;
  final ValueChanged<Country> onChanged;

  const CountryPicker({
    super.key,
    required this.countries,
    required this.onChanged,
  });

  @override
  State<CountryPicker> createState() => CountryPickerState();
}

class CountryPickerState extends State<CountryPicker> {
  late Country selected;

  @override
  void initState() {
    super.initState();
    selected = widget.countries.firstWhere(
      (country) => country.code == Localizations.localeOf(context).countryCode,
      orElse: () => widget.countries.first,
    );
    widget.onChanged(selected);
  }

  Future<Country?> showCountryDialog() => showDialog<Country>(
        context: context,
        builder: (context) => CountryPickerDialog(countries: widget.countries),
      );

  void changeSelectedCountry(Country country) {
    if (country != selected) {
      setState(() => selected = country);
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const StadiumBorder(),
      onTap: () async {
        final country = await showCountryDialog();
        if (country != null) changeSelectedCountry(country);
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
              selected.phoneCodeFormatted,
              // TextField default style
              style: context.textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
