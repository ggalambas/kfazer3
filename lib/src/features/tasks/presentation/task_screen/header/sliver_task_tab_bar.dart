import 'package:flutter/material.dart';
import 'package:kfazer3/src/features/tasks/domain/task_screen_tab.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

class SliverTaskTabBar extends StatelessWidget {
  const SliverTaskTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverTaskTabBarDelegate(),
    );
  }
}

class SliverTaskTabBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => kTextTabBarHeight;
  @override
  double get minExtent => kTextTabBarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return TabBar(
      // Indicator and label colors must be defined for the light mode
      indicatorColor: context.colorScheme.onBackground,
      labelColor: context.colorScheme.onBackground,
      tabs: [
        for (final tab in TaskScreenTab.values) Tab(text: tab.name.hardcoded),
      ],
    );
  }
}
