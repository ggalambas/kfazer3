import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/settings/data/settings_repository.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class SelectionSettingTile<T extends Enum> extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<SettingNotifier<T>, T> provider;
  final IconData icon;
  final String title;
  final String? description;
  final List<T> options;

  const SelectionSettingTile({
    super.key,
    required this.provider,
    required this.icon,
    required this.title,
    this.description,
    required this.options,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);
    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(title),
          children: options
              .map(
                (option) => RadioListTile(
                  value: option,
                  groupValue: value,
                  onChanged: (newValue) {
                    ref.read(provider.notifier).state = newValue as T;
                    Navigator.pop(context);
                  },
                  title: Text(option.name.hardcoded),
                ),
              )
              .toList(),
        ),
      ),
      leading: Icon(icon),
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailing: Text(
        value.name.hardcoded,
        style: context.textTheme.labelMedium!.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
