import 'package:flutter/widgets.dart';

mixin LocalizedEnum on Enum {
  String locName(BuildContext context);
}
