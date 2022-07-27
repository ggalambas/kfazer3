import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class SelectionSettingTile<T extends Enum> extends ConsumerStatefulWidget {
  final IconData icon;
  final String title;
  final String? description;
  final List<T> options;

  const SelectionSettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    required this.options,
  });

  @override
  ConsumerState<SelectionSettingTile> createState() =>
      _SelectionSettingTileState<T>();
}

class _SelectionSettingTileState<T extends Enum>
    extends ConsumerState<SelectionSettingTile> {
  @override
  Widget build(BuildContext context) {
    final value =
        ref.watch(settingsRepositoryProvider).getSetting(widget.options);
    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(widget.title),
          children: widget.options
              .map(
                (option) => RadioListTile(
                  value: option,
                  groupValue: value,
                  onChanged: (newValue) {
                    ref
                        .read(settingsRepositoryProvider)
                        .setSetting(newValue! as T);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  title: Text(option.name.hardcoded),
                ),
              )
              .toList(),
        ),
      ),
      leading: Icon(widget.icon),
      title: Text(widget.title),
      subtitle: widget.description == null ? null : Text(widget.description!),
      trailing: Text(
        value.name.hardcoded,
        style: context.textTheme.labelMedium!.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
