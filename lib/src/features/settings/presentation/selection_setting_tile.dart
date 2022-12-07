import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/circular_progress_icon.dart';
import 'package:kfazer3/src/localization/localized_enum.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class SelectionSettingTile<T extends LocalizedEnum> extends StatelessWidget {
  final bool loading;
  final T selected;
  final ValueChanged<T> onChanged;
  final List<T> options;
  final IconData icon;
  final String title;
  final String? description;

  const SelectionSettingTile({
    super.key,
    this.loading = false,
    required this.selected,
    required this.onChanged,
    required this.options,
    required this.icon,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(title),
          children: options
              .map(
                (option) => RadioListTile<T>(
                  value: option,
                  groupValue: selected,
                  onChanged: (newValue) {
                    onChanged(newValue as T);
                    Navigator.pop(context);
                  },
                  title: Text(option.locName(context)),
                ),
              )
              .toList(),
        ),
      ),
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailing: loading
          ? const CircularProgressIcon()
          : Text(
              selected.locName(context),
              style: context.textTheme.labelMedium!.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
    );
  }
}
