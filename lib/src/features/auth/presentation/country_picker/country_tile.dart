import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/avatar/avatar.dart';
import 'package:kfazer3/src/features/auth/domain/country.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/widget_loader.dart';

/// Used to show a single country inside a list tile.
class CountryTile extends StatelessWidget {
  final Country country;
  const CountryTile(this.country, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Avatar(
        text: country.code.split('').join(' '),
        radius: 12,
        foregroundImage: NetworkImage(country.flagUrl, scale: 0.2),
      ),
      title: Text(country.name),
      trailing: Text(country.phoneCode),
      onTap: () => Navigator.pop(context, country),
    );
  }
}

/// The loading widget for [CountryTile].
class LoadingCountryTile extends StatelessWidget {
  const LoadingCountryTile({super.key});

  @override
  Widget build(BuildContext context) {
    final textHeight = context.textTheme.bodyMedium!.fontSize!;
    return ListTile(
      dense: true,
      leading: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colorScheme.surfaceVariant,
        ),
      ),
      title: Container(
        height: textHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(textHeight / 2),
          color: context.colorScheme.surfaceVariant,
        ),
      ),
      trailing: Container(
        height: textHeight,
        width: 32, //! hardcoded
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(textHeight / 2),
          color: context.colorScheme.surfaceVariant,
        ),
      ),
    ).loader(context);
  }
}
