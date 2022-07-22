import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

import 'country_picker_dialog.dart';

class CountryController extends StateNotifier<Country?> {
  CountryController() : super(null);
  Country? get _valueOrNull => state;
  Country get value => state!;
  set value(Country country) => state = country;
}

class CountryPicker extends StatefulWidget {
  final CountryController? controller;
  final List<Country> countries;
  const CountryPicker({super.key, this.controller, required this.countries});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  late final controller = widget.controller ?? CountryController();
  var hasListener = false;

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  void initController(BuildContext context) {
    final countryCode = Localizations.localeOf(context).countryCode;
    controller.value = widget.countries.firstWhere(
      (country) => country.code == countryCode,
      orElse: () => widget.countries.first,
    );
  }

  void addListener() {
    controller.addListener((_) => setState(() {}));
    hasListener = true;
  }

  Future<Country?> showCountryDialog(BuildContext context) =>
      showDialog<Country>(
        context: context,
        builder: (context) => CountryPickerDialog(countries: widget.countries),
      );

  @override
  Widget build(BuildContext context) {
    if (controller._valueOrNull == null) initController(context);
    if (!hasListener) addListener();

    return InkWell(
      customBorder: const StadiumBorder(),
      onTap: () async {
        final country = await showCountryDialog(context);
        if (country != null) controller.value = country;
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
              controller.value.phoneCode,
              // TextField default style
              style: context.textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}

/// Text field prefix equivalent of [CountryPicker]
class CountryPickerPrefix extends StatelessWidget {
  final CountryController? controller;
  final List<Country> countries;

  const CountryPickerPrefix({
    super.key,
    this.controller,
    required this.countries,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: kSpace),
      child: CountryPicker(controller: controller, countries: countries),
    );
  }
}
