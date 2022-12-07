import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/setup_layout.dart';
import 'package:kfazer3/src/features/groups/presentation/group_setup/group_setup_controller.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

import 'group_name_field.dart';

class GroupDetailsPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const GroupDetailsPage({super.key, required this.onSuccess});

  @override
  ConsumerState<GroupDetailsPage> createState() => GroupDetailsPageState();
}

class GroupDetailsPageState extends ConsumerState<GroupDetailsPage> {
  final formKey = GlobalKey<FormState>();
  final nameNode = FocusNode();
  final nameController = TextEditingController();

  String get name => nameController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;
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
    return SetupLayout(
      formKey: formKey,
      title: 'Let\'s create a Group'.hardcoded,
      description: TextSpan(
        text:
            'This is the name of your company, team or organization. You will later be able to add a photo and a description.'
                .hardcoded,
      ),
      content: [
        GroupNameField(
          focusNode: nameNode,
          controller: nameController,
          onSubmit: submit,
          submitted: submitted,
        ),
      ],
      cta: [
        ElevatedButton(
          onPressed: submit,
          child: Text(context.loc.next),
        ),
      ],
    );
  }
}
