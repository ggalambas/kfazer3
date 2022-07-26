import 'package:flutter/material.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/int_to_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_space/smart_space.dart';

class NotificationListSkeleton extends StatelessWidget {
  const NotificationListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final itemCount = height ~/ NotificationSkeleton.height(context);
    return Column(
      children: itemCount
          .generateList()
          .map((_) => const NotificationSkeleton())
          .toList(),
    );
  }
}

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

// height: paragraph + spacing + padding
  static double height(BuildContext context) =>
      context.textTheme.bodyMedium!.fontSize! * 2 + 12 + 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kSpace * 2),
      height: height(context),
      child: Row(
        children: [
          const SkeletonAvatar(
            style: SkeletonAvatarStyle(
              height: 32,
              width: 32,
              shape: BoxShape.circle,
            ),
          ),
          Space(2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: context.textTheme.bodyMedium!.fontSize,
                  ),
                ),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    randomLength: true,
                    padding: const EdgeInsets.only(right: 56),
                    height: context.textTheme.bodyMedium!.fontSize,
                  ),
                ),
              ],
            ),
          ),
          Space(2),
          SizedBox(
            width: 56,
            child: SkeletonLine(
              style: SkeletonLineStyle(
                height: context.textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
