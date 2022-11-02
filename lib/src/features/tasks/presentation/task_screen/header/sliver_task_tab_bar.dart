import 'package:flutter/material.dart';
import 'package:kfazer3/src/localization/string_hardcoded.dart';
import 'package:kfazer3/src/utils/context_theme.dart';

/// The two tabs that are presented in the task screen.
enum TaskScreenTab { details, comments }

class SliverTaskTabBar extends StatelessWidget {
  final TabController? controller;
  final ValueChanged<int>? onTap;
  const SliverTaskTabBar({super.key, this.controller, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverTaskTabBarDelegate(
        controller: controller,
        onTap: onTap,
      ),
    );
  }
}

class SliverTaskTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController? controller;
  final ValueChanged<int>? onTap;
  const SliverTaskTabBarDelegate({this.controller, this.onTap});

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
    return Material(
      color: context.colorScheme.background,
      child: TabBar(
        // Indicator and label colors must be defined for the light mode
        controller: controller,
        onTap: onTap,
        indicatorColor: context.colorScheme.onBackground,
        labelColor: context.colorScheme.onBackground,
        tabs: [
          for (final tab in TaskScreenTab.values) Tab(text: tab.name.hardcoded),
        ],
      ),
    );
  }
}
