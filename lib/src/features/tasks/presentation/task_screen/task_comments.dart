import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfazer3/src/features/tasks/domain/task.dart';

/// Shows the task comments
class TaskComments extends ConsumerWidget {
  final Task task;
  const TaskComments({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Text('comments...'),
      // bottomSheet: Padding(
      //   padding: EdgeInsets.all(kSpace),
      //   child: TextFormField(
      //     // focusNode: nameNode,
      //     // controller: nameController,
      //     keyboardType: TextInputType.multiline,
      //     textInputAction: TextInputAction.send,
      //     // maxLength: kNameLength,
      //     decoration: InputDecoration(
      //       // counterText: '',
      //       labelText: 'Comment'.hardcoded,
      //     ),
      //     // onEditingComplete: submit,
      //     // autovalidateMode: AutovalidateMode.onUserInteraction,
      //     // validator: (name) {
      //     // if (!submitted) return null;
      //     // return ref
      //     // .read(signInControllerProvider.notifier)
      //     // .nameErrorText(context, name ?? '');
      //     // },
      //   ),
      // ),
    );
  }
}
