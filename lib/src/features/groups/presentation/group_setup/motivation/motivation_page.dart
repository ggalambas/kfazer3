import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/extensions/num_duration_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/common_widgets/setup_layout.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:kfazer3/src/constants/constants.dart';
import 'package:kfazer3/src/constants/test_groups.dart';
import 'package:kfazer3/src/features/groups/presentation/group_setup/group_setup_controller.dart';
import 'package:kfazer3/src/features/groups/presentation/motivation/motivation_validators.dart';
import 'package:kfazer3/src/localization/localized_context.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:smart_space/smart_space.dart';

class MotivationPage extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const MotivationPage({super.key, required this.onSuccess});

  @override
  ConsumerState<MotivationPage> createState() => _MotivationPageState();
}

class _MotivationPageState extends ConsumerState<MotivationPage> {
  final formKey = GlobalKey<FormState>();
  List<FocusNode>? messageNodes;
  List<TextEditingController>? messageControllers;

  final scrollController = ScrollController();

  List<String> get messages =>
      messageControllers!.map((controller) => controller.text).toList();

  void init() {
    if (messageControllers != null) return;

    messageControllers = [];
    messageNodes = [];
    //TODO get workpsace default messages
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

  void clear() => setState(() {
        messageControllers!.clear();
        messageNodes!.clear();
      });

  void add() async {
    setState(() {
      messageControllers!.add(TextEditingController());
      messageNodes!.add(FocusNode());
    });
    messageNodes!.last.requestFocus();
    await Future.delayed(100.ms);
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void submit() async {
    if (messageNodes!.isNotEmpty) {
      messageNodes!.last
        ..requestFocus()
        ..nextFocus()
        ..unfocus();
    }
    if (!formKey.currentState!.validate()) return;

    final controller = ref.read(groupSetupControllerProvider.notifier);
    controller.saveMessages(messages);
    widget.onSuccess?.call();
  }

  @override
  Widget build(BuildContext context) {
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
                          validator: (message) => ref
                              .read(groupSetupControllerProvider.notifier)
                              .messageErrorText(context, message ?? ''),
                        ),
                      )
                      .expandIndexed((i, textField) => [
                            textField,
                            const Divider(),
                          ]),
                  if (messageControllers!.length > 1)
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: context.colorScheme.error,
                      ),
                      onPressed: clear,
                      child: const Text('Clear all'),
                    ),
                ],
              ),
            ),
          ],
          cta: [
            OutlinedButton(
              onPressed: add,
              child: Text('Add new message'.hardcoded),
            ),
            ElevatedButton(
              onPressed: submit,
              child: Text(context.loc.next),
            ),
          ],
        );
      },
    );
  }
}
