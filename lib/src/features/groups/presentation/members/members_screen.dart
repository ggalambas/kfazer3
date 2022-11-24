// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kfazer3/src/common_widgets/async_value_widget.dart';
// import 'package:kfazer3/src/common_widgets/responsive_scaffold.dart';
// import 'package:kfazer3/src/features/auth/domain/app_user.dart';
// import 'package:kfazer3/src/features/groups/data/groups_repository.dart';
// import 'package:kfazer3/src/features/groups/domain/group.dart';
// import 'package:kfazer3/src/features/groups/presentation/not_found_group.dart';
// import 'package:kfazer3/src/features/users/data/users_repository.dart';
// import 'package:kfazer3/src/localization/app_localizations_context.dart';

// class MembersScreen extends ConsumerWidget {
//   final String groupId;
//   const MembersScreen({super.key, required this.groupId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final groupValue = ref.watch(groupStreamProvider(groupId));
//     return AsyncValueWidget<Group?>(
//       value: groupValue,
//       data: (group) {
//         if (group == null) return const NotFoundGroup();
//         // final preferences = preferenceList(context, ref, group);
//         //TODO sort
//         final memberRoles = group.memberRoles;
//         return ResponsiveScaffold.builder(
//           appBar: AppBar(title: Text(context.loc.preferences)),
//           rail: Rail(title: context.loc.preferences),
//           body: (isOneColumn) {
//             // return isOneColumn
//             // ? ListView(children: preferences)
//             // : SingleChildScrollView(child: Column(children: preferences));
//             return ListView(
//               children: [
//                 for (final userId in memberRoles.keys)
//                   Consumer(
//                     builder: (context, ref, _) {
//                       final userValue = ref.watch(userStreamProvider(userId));
//                       return AsyncValueWidget<AppUser?>(
//                         value: userValue,
//                         data: (user) {
//                           return null;
//                         },
//                       );
//                     },
//                   ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
