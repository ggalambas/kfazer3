import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/utils/int_to_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_space/smart_space.dart';

class WorkspaceListSkeleton extends StatelessWidget {
  const WorkspaceListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // workspace avatar diameter + padding + margin
        const itemHeight = 64; // 40+16+8
        final itemCount = ((constraints.maxHeight - 16) / itemHeight).floor();
        return ResponsiveCenter(
          padding: EdgeInsets.all(kSpace),
          child: Column(
            children: [
              ...itemCount.generateList().map(
                    (_) => SkeletonItem(
                      child: Card(
                        child: SizedBox.fromSize(
                          // workspace avatar diameter + padding
                          size: const Size.fromHeight(56), // 40+16
                        ),
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
