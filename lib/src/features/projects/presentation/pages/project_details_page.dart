// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kfazer3/src/common_widgets/setup_layout.dart';
// import 'package:kfazer3/src/constants/constants.dart';
// import 'package:kfazer3/src/features/groups/presentation/group_setup/group_setup_controller.dart';
// import 'package:kfazer3/src/features/groups/presentation/group_validators.dart';
// import 'package:kfazer3/src/localization/localized_context.dart';
// import 'package:kfazer3/src/localization/string_hardcoded.dart';

// class GroupDetailsPage extends ConsumerStatefulWidget {
//   final VoidCallback? onSuccess;
//   const GroupDetailsPage({super.key, required this.onSuccess});

//   @override
//   ConsumerState<GroupDetailsPage> createState() => GroupDetailsPageState();
// }

// class GroupDetailsPageState extends ConsumerState<GroupDetailsPage> {
//   final formKey = GlobalKey<FormState>();
//   final titleNode = FocusNode();
//   final titleController = TextEditingController();

//   String get title => titleController.text;

//   // local variable used to apply AutovalidateMode.onUserInteraction and show
//   // error hints only when the form has been submitted
//   // For more details on how this is implemented, see:
//   // https://codewithandrea.com/articles/flutter-text-field-form-validation/
//   var submitted = false;
//   void submit() async {
//     titleNode
//       ..nextFocus()
//       ..unfocus();
//     setState(() => submitted = true);
//     if (!formKey.currentState!.validate()) return;
//     ref.read(groupSetupControllerProvider.notifier).saveTitle(title);
//     widget.onSuccess?.call();
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     titleNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SetupLayout(
//       formKey: formKey,
//       title: 'Name your group'.hardcoded,
//       description: TextSpan(
//         text:
//             'A group is where you can structure a team and manage your tasks. You will later be able to add a photo and a description.'
//                 .hardcoded,
//       ),
//       content: [
//         TitleFormField(
//           focusNode: titleNode,
//           controller: titleController,
//           onSubmit: submit,
//           submitted: submitted,
//         ),
//       ],
//       cta: [
//         ElevatedButton(
//           onPressed: submit,
//           child: Text(context.loc.next),
//         ),
//       ],
//     );
//   }
// }

// //TODO move to another file?
// class TitleFormField extends ConsumerWidget {
//   final FocusNode focusNode;
//   final TextEditingController controller;
//   final VoidCallback onSubmit;
//   final bool submitted;

//   const TitleFormField({
//     super.key,
//     required this.focusNode,
//     required this.controller,
//     required this.onSubmit,
//     required this.submitted,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return TextFormField(
//       focusNode: focusNode,
//       controller: controller,
//       keyboardType: TextInputType.name,
//       textInputAction: TextInputAction.done,
//       maxLength: kTitleLength,
//       decoration: InputDecoration(
//         counterText: '',
//         labelText: context.loc.title,
//       ),
//       onEditingComplete: onSubmit,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       validator: (title) {
//         if (!submitted) return null;
//         return ref
//             .read(groupSetupControllerProvider.notifier)
//             .titleErrorText(context, title ?? '');
//       },
//     );
//   }
// }
