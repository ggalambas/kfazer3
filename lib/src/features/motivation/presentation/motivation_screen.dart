import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivational_message_field.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';

class MotivationScreen extends ConsumerWidget {
  final String groupId;
  const MotivationScreen({super.key, required this.groupId});

  void edit(BuildContext context) {
    context.goNamed(
      AppRoute.motivation.name,
      queryParams: {'editing': 'true'},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupValue = ref.watch(groupStreamProvider(groupId));
    return AsyncValueWidget<Group?>(
      value: groupValue,
      data: (group) {
        if (group == null) return const NotFoundGroup();
        return ResponsiveScaffold(
          appBar: DetailsBar(
            title: context.loc.motivation,
            onEdit: () => edit(context),
          ),
          rail: DetailsRail(
            title: context.loc.motivation,
            onEdit: () => edit(context),
            editText: context.loc.editMotivationalMessages,
          ),
          builder: (railPadding) => ListView.separated(
            padding: railPadding,
            itemCount: group.motivationalMessages.length,
            separatorBuilder: (context, _) => const Divider(),
            itemBuilder: (context, i) => MotivationalMessageDisplayField(
              group.motivationalMessages[i],
            ),
          ),
        );
      },
    );
  }
}
