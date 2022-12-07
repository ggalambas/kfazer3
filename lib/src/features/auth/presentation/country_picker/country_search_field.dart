import 'package:flutter/material.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:smart_space/smart_space.dart';

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
