import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/utils/context_theme.dart';
import 'package:kfazer3/src/utils/int_to_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_space/smart_space.dart';

class NotificationListSkeleton extends StatelessWidget {
  const NotificationListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // paragraph heigh + line spacing + padding
        final itemHeight = context.textTheme.bodyMedium!.fontSize! * 2 + 8 + 16;
        final itemCount = ((constraints.maxHeight - 16) / itemHeight).floor();
        return ResponsiveCenter(
          padding: EdgeInsets.symmetric(vertical: kSpace),
          child: Column(
            children: [
              ...itemCount.generateList().map(
                    (_) => Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: kSpace,
                        horizontal: kSpace * 2,
                      ),
                      child: Row(
                        children: [
                          const SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              height: 32,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Space(2),
                          Expanded(
                            child: SkeletonParagraph(
                              style: SkeletonParagraphStyle(
                                padding: EdgeInsets.zero,
                                lines: 2,
                                spacing: 8,
                                lineStyle: SkeletonLineStyle(
                                  height:
                                      context.textTheme.bodyMedium!.fontSize,
                                ),
                              ),
                            ),
                          ),
                          Space(2),
                          SizedBox(
                            width: 48,
                            child: SkeletonLine(
                              style: SkeletonLineStyle(
                                height: context.textTheme.bodyMedium!.fontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
            ],
          ),
        );
      },
    );
  }
}
