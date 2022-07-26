import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/int_to_list.dart';
import 'package:skeletons/skeletons.dart';

class WorkspaceListSkeleton extends StatelessWidget {
  const WorkspaceListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final itemCount = (height / WorkspaceSkeleton.height(context)).ceil();
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: itemCount
          .generateList()
          .map((_) => const WorkspaceSkeleton())
          .toList(),
    );
  }
}

class WorkspaceSkeleton extends StatelessWidget {
  const WorkspaceSkeleton({super.key});

  // height: workspace avatar diameter + padding + margin
  static double height(BuildContext context) => 40 + 16 + 18;

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Card(
        child: SizedBox.fromSize(
          // workspace avatar diameter + padding
          size: const Size.fromHeight(56), // 40+16
        ),
      ),
    );
  }
}
