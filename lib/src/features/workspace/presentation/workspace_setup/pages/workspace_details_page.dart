import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/setup_layout.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';

class WorkspaceDetailsPage extends StatefulWidget {
  final VoidCallback? onSuccess;
  const WorkspaceDetailsPage({super.key, required this.onSuccess});

  @override
  State<WorkspaceDetailsPage> createState() => _WorkspaceDetailsPageState();
}

class _WorkspaceDetailsPageState extends State<WorkspaceDetailsPage> {
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

    // final controller = ref.read(signInControllerProvider.notifier);
    // final success = await controller.submit();
    // if (success)
    widget.onSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(signInControllerProvider);
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
          decoration: InputDecoration(labelText: context.loc.title),
          onEditingComplete: submit,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (title) {
            return null;
            // if (!submitted) return null;
            // return ref
            //     .read(signInControllerProvider.notifier)
            //     .phoneNumberErrorText(context, phoneNumber ?? '');
          },
        ),
      ],
      cta: [
        LoadingElevatedButton(
          // loading: state.isLoading,
          onPressed: submit,
          child: Text(context.loc.next), //!
        ),
      ],
    );
  }
}
