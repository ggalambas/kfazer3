import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kfazer3/src/common_widgets/responsive_setup.dart';
import 'package:kfazer3/src/features/groups/presentation/group_setup/group_setup_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/routing/app_router.dart';

import 'group_name_field.dart';

class GroupDetailsPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const GroupDetailsPage({super.key, required this.onSuccess});

  @override
  ConsumerState<GroupDetailsPage> createState() => GroupDetailsPageState();
}

/// Use the [AutomaticKeepAliveClientMixin] to keep the state.
class GroupDetailsPageState extends ConsumerState<GroupDetailsPage>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final nameController = TextEditingController();

  String get name => nameController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  // override `wantKeepAlive` when using `AutomaticKeepAliveClientMixin`
  @override
  bool get wantKeepAlive => true;

  void submit() async {
    nameNode
      ..nextFocus()
      ..unfocus();
    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;
    ref.read(groupSetupControllerProvider.notifier).saveName(name);
    widget.onSuccess?.call();
  }

  @override
  void dispose() {
    nameController.dispose();
    nameNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // call `super.build` when using `AutomaticKeepAliveClientMixin`
    super.build(context);

    return ResponsiveSetup(
      formKey: formKey,
      onCancel: () => context.goNamed(AppRoute.home.name),
      title: 'Let\'s create a Group'.hardcoded,
      description:
          'This is the name of your company, team or organization. You will later be able to add a photo and a description.'
              .hardcoded,
      content: GroupNameField(
        focusNode: nameNode,
        controller: nameController,
        onSubmit: submit,
        submitted: submitted,
      ),
      actions: [
        ElevatedButton(
          onPressed: submit,
          child: Text(context.loc.next),
        ),
      ],
    );
  }
}
