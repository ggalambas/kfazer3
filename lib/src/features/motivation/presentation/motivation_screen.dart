import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/motivation/data/motivation_repository.dart';
import 'package:kfazer3/src/features/motivation/domain/motivation.dart';
import 'package:kfazer3/src/features/motivation/presentation/motivational_message_field.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:smart_space/smart_space.dart';

class MotivationScreen extends ConsumerWidget {
  final String groupId;
  const MotivationScreen({super.key, required this.groupId});

  void edit(BuildContext context) {
    context.goNamed(
      AppRoute.motivation.name,
      params: {'groupId': groupId},
      queryParams: {'editing': 'true'},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motivationValue = ref.watch(motivationStreamProvider(groupId));
    return AsyncValueWidget<Motivation>(
      value: motivationValue,
      data: (motivation) {
        //TODO not found group on motivation edit screen
        // if (messageControllers == null) return const NotFoundGroup();
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
          builder: (topPadding) => ListView.separated(
            padding: EdgeInsets.all(kSpace).add(
              EdgeInsets.only(top: topPadding),
            ),
            itemCount: motivation.length,
            separatorBuilder: (context, _) => const Divider(),
            itemBuilder: (context, i) => MotivationalMessageDisplayField(
              motivation[i],
            ),
          ),
        );
      },
    );
  }
}
