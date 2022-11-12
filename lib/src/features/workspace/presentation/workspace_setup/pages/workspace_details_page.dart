import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/setup_layout.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/features/groups/presentation/group_validators.dart';
import 'package:kfazer3/src/features/workspace/presentation/workspace_setup/workspace_setup_controller.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class WorkspaceDetailsPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const WorkspaceDetailsPage({super.key, required this.onSuccess});

  @override
  ConsumerState<WorkspaceDetailsPage> createState() =>
      _WorkspaceDetailsPageState();
}

class _WorkspaceDetailsPageState extends ConsumerState<WorkspaceDetailsPage> {
  final formKey = GlobalKey<FormState>();
  final titleNode = FocusNode();
  final titleController = TextEditingController();

  String get title => titleController.text;

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  @override
  void dispose() {
    titleController.dispose();
    titleNode.dispose();
    super.dispose();
  }

  void submit() async {
    titleNode
      ..nextFocus()
      ..unfocus();

    setState(() => submitted = true);
    if (!formKey.currentState!.validate()) return;

    final controller = ref.read(workspaceSetupControllerProvider.notifier);
    controller.saveTitle(title);
    widget.onSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SetupLayout(
      formKey: formKey,
      title: 'Name your workspace'.hardcoded,
      description: TextSpan(
        text:
            'A workspace is where you can structure a team and manage your tasks. You will later be able to add a photo and a description.'
                .hardcoded,
      ),
      content: [
        TextFormField(
          focusNode: titleNode,
          controller: titleController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.done,
          maxLength: kTitleLength,
          decoration: InputDecoration(
            counterText: '',
            labelText: context.loc.title,
          ),
          onEditingComplete: submit,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (title) {
            if (!submitted) return null;
            return ref
                .read(workspaceSetupControllerProvider.notifier)
                .titleErrorText(context, title ?? '');
          },
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
