import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/loading_button.dart';
import 'package:kfazer3/src/common_widgets/setup_layout.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/constants/test_workspaces.dart';
import 'package:kfazer3/src/localization/app_localizations_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:smart_space/smart_space.dart';

class MotivationPage extends StatefulWidget {
  final VoidCallback? onSuccess;
  const MotivationPage({super.key, required this.onSuccess});

  @override
  State<MotivationPage> createState() => _MotivationPageState();
}

class _MotivationPageState extends State<MotivationPage> {
  final formKey = GlobalKey<FormState>();
  List<FocusNode>? messageNodes;
  List<TextEditingController>? messageControllers;

  final scrollController = ScrollController();

  List<String> get messages =>
      messageControllers!.map((controller) => controller.text).toList();

  // local variable used to apply AutovalidateMode.onUserInteraction and show
  // error hints only when the form has been submitted
  // For more details on how this is implemented, see:
  // https://codewithandrea.com/articles/flutter-text-field-form-validation/
  var submitted = false;

  void init() {
    if (messageControllers != null) return;

    messageControllers = [];
    messageNodes = [];
    //!
    for (final message in kMotivationalMessages) {
      messageControllers!.add(TextEditingController(text: message));
      messageNodes!.add(FocusNode());
    }
  }

  @override
  void dispose() {
    messageControllers?.forEach((controller) => controller.dispose());
    messageNodes?.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void delete(TextEditingController controller) => setState(() {
        final i = messageControllers!.indexOf(controller);
        messageControllers!.removeAt(i);
        messageNodes!.removeAt(i);
      });

  void add() async {
    setState(() {
      messageControllers!.add(TextEditingController());
      messageNodes!.add(FocusNode());
    });
    messageNodes!.last.requestFocus();
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void submit() async {
    messageNodes!.last
      ..requestFocus()
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
    init();
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSingleColumn = constraints.maxWidth < Breakpoint.tablet;
        return SetupLayout(
          formKey: formKey,
          title: 'Motivate your employees'.hardcoded,
          description: TextSpan(
            text:
                'Motivational messages are shown when completing a task, so you can keep everyone motivated at all times. You can manage your messages later in the settings.\n\n'
                        'We\'ve added some messages to get you started!'
                    .hardcoded,
          ),
          content: [
            SizedBox(
              height: isSingleColumn
                  ? null
                  : MediaQuery.of(context).size.height * 0.5,
              child: ListView(
                shrinkWrap: isSingleColumn,
                controller: scrollController,
                physics: isSingleColumn
                    ? const NeverScrollableScrollPhysics()
                    : null,
                children: [
                  ...messageControllers!
                      .mapIndexed(
                        (i, messageController) => TextFormField(
                          focusNode: messageNodes![i],
                          controller: messageController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          maxLength: kMotivationalMessagesLength,
                          maxLines: null,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: false,
                            isDense: true,
                            contentPadding: EdgeInsets.all(kSpace),
                            suffixIcon: IconButton(
                              tooltip: context.loc.delete,
                              onPressed: () => delete(messageController),
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (message) {
                            return null;
                            // if (!submitted) return null;
                            // return ref
                            //     .read(motivationEditScreenControllerProvider
                            //         .notifier)
                            //     .messageErrorText(context, message ?? '');
                          },
                        ),
                      )
                      .expandIndexed((i, textField) => [
                            textField,
                            if (i < messageControllers!.length - 1)
                              const Divider(),
                          ]),
                ],
              ),
            ),
          ],
          cta: [
            LoadingOutlinedButton(
              // loading: smsCodeController.isLoading,
              onPressed: add,
              child: Text('Add new message'.hardcoded),
            ),
            LoadingElevatedButton(
              // loading: state.isLoading,
              onPressed: submit,
              child: Text(context.loc.next), //!
            ),
          ],
        );
      },
    );
  }
}
