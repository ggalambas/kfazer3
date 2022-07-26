import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_message_widget.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? loading;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (e, _) => Material(
        child: Center(
          child: ErrorMessageWidget(e.toString()),
        ),
      ),
      loading: () =>
          loading ??
          const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
