import 'package:flutter/material.dart';

mixin QuoteForm<T extends StatefulWidget> on State<T> {
  final quoteControllers = <TextEditingController>[];

  bool _initialized = false;
  void initQuoteController(List<String> quotes) {
    if (_initialized) return;
    _initialized = true;
    quoteControllers.addAll(
      quotes.map((quote) => TextEditingController(text: quote)),
    );
  }

  List<String> get quotes => quoteControllers.map((c) => c.text).toList();

  void addQuote() {
    setState(() {
      quoteControllers.insert(0, TextEditingController());
    });
  }

  void removeQuote(int i) {
    setState(() {
      final controller = quoteControllers.removeAt(i);
      controller.dispose();
    });
  }

  void clearAllQuotes() {
    setState(() {
      final controllers = List<TextEditingController>.from(quoteControllers);
      quoteControllers.clear();
      for (final controller in controllers) {
        controller.dispose();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in quoteControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
