import 'package:flutter/material.dart';

class SliverSeparatedChildBuilderDelegate extends SliverChildBuilderDelegate {
  SliverSeparatedChildBuilderDelegate(
    IndexedWidgetBuilder itemBuilder, {
    required IndexedWidgetBuilder separatorBuilder,
    required int childCount,
  }) : super(
          childCount: childCount * 2 - 1,
          (context, index) {
            final itemIndex = index ~/ 2;
            if (index.isOdd) return separatorBuilder(context, itemIndex);
            return itemBuilder(context, itemIndex);
          },
        );
}
