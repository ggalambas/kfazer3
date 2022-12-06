import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
import 'package:kfazer3/src/common_widgets/avatar/group_avatar.dart';
import 'package:kfazer3/src/common_widgets/details_bar.dart';
import 'package:kfazer3/src/common_widgets/loading_dialog.dart';
import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
import 'package:kfazer3/src/features/auth/data/auth_repository.dart';
import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
import 'package:kfazer3/src/features/groups/domain/group.dart';
import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/routing/app_router.dart';
import 'package:kfazer3/src/utils/async_value_ui.dart';
import 'package:smart_space/smart_space.dart';

import 'group_details_controller.dart';

class GroupDetailsScreen extends ConsumerStatefulWidget {
  final String groupId;
  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends ConsumerState<GroupDetailsScreen> {
  void edit() {
    context.goNamed(
      AppRoute.groupDetails.name,
      params: {'groupId': widget.groupId},
      queryParams: {'editing': 'true'},
    );
  }

  void delete(Group group) => showLoadingDialog(
        context: context,
        title: context.loc.areYouSure,
        cancelActionText: context.loc.cancel,
        defaultActionText: context.loc.delete,
        onDefaultAction: () async {
          final success = await ref
              .read(groupDetailsControllerProvider.notifier)
              .deleteGroup(widget.groupId);
          if (mounted && success) context.goNamed(AppRoute.home.name);
        },
      );

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      groupDetailsControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(groupDetailsControllerProvider);
    final groupValue = ref.watch(groupStreamProvider(widget.groupId));
    final currentUser = ref.watch(currentUserStateProvider);

    return AsyncValueWidget<Group?>(
      value: groupValue,
      data: (group) {
        if (group == null) return const NotFoundGroup();
        final role = group.members[currentUser.id]!;

        return ResponsiveScaffold(
          padding: EdgeInsets.all(kSpace * 2),
          appBar: DetailsBar(
            loading: state.isLoading,
            title: context.loc.group,
            onEdit: edit,
            deleteText: context.loc.deleteGroup,
            onDelete: role.isOwner ? () => delete(group) : null,
          ),
          rail: DetailsRail(
            title: context.loc.group,
            loading: state.isLoading,
            editText: context.loc.editGroup,
            onEdit: edit,
            deleteText: context.loc.deleteGroup,
            onDelete: role.isOwner ? () => delete(group) : null,
          ),
          builder: (topPadding) => ListView(
            padding: EdgeInsets.only(top: topPadding),
            children: [
              Center(
                child: GroupAvatar(
                  group,
                  radius: kSpace * 10,
                  dialogOnTap: false,
                ),
              ),
              Space(4),
              TextFormField(
                enabled: false,
                initialValue: group.title,
                decoration: InputDecoration(
                  labelText: context.loc.title,
                ),
              ),
              Space(),
              TextFormField(
                enabled: false,
                initialValue: group.description,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: context.loc.description,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
