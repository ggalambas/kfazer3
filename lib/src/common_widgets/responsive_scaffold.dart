import 'package:flutter/material.dart';
import 'package:kfazer3/src/common_widgets/responsive_center.dart';
import 'package:kfazer3/src/constants/breakpoints.dart';
import 'package:smart_space/smart_space.dart';

typedef BodyBuilder = Widget Function(bool);

/// Responsive layout that shows
/// two the appbar and the body side by side if there is enough space,
/// or the standard scaffold if there is not enough space.
class ResponsiveScaffold extends StatelessWidget {
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final PreferredSizeWidget? appBar;
  final Widget? rail;
  final Widget? body;
  final BodyBuilder? builder;

  const ResponsiveScaffold({
    super.key,
    this.maxContentWidth = Breakpoint.tablet,
    this.padding = EdgeInsets.zero,
    this.appBar,
    this.rail,
    required Widget this.body,
  }) : builder = null;

  const ResponsiveScaffold.builder({
    super.key,
    this.maxContentWidth = Breakpoint.tablet,
    this.padding = EdgeInsets.zero,
    this.appBar,
    this.rail,
    required BodyBuilder body,
  })  : body = null,
        builder = body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= maxContentWidth) {
        return Scaffold(
          body: ResponsiveCenter(
            maxContentWidth: Breakpoint.desktop,
            padding: EdgeInsets.all(kSpace * 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rail != null) Expanded(flex: 1, child: rail!),
                Space(3),
                Expanded(flex: 2, child: body ?? builder!(false)),
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: appBar,
          body: ResponsiveCenter(
            padding: padding,
            child: body ?? builder!(true),
          ),
        );
      }
    });
  }
}
