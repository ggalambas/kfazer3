import 'package:flutter_animate/extensions/num_duration_extensions.dart';

Future<void> delay(bool addDelay, [int milliseconds = 1000]) async {
  if (addDelay) return Future.delayed(milliseconds.ms);
}
