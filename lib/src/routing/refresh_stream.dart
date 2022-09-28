import 'dart:async';

import 'package:flutter/cupertino.dart';

class RefreshStream extends ChangeNotifier {
  late final StreamSubscription sub;

  RefreshStream(Stream stream) {
    notifyListeners();
    sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}
