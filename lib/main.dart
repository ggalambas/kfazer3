import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'src/app.dart';
import 'src/localization/string_hardcoded.dart';

void main() async {
  // For more info on error handling, see:
  // https://docs.flutter.dev/testing/errors
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // turn off the # in the URLs on the web
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
    // Entry point of the app
    runApp(const ProviderScope(child: MyApp()));

    // This code will present some error UI if any uncaught exception happens
    FlutterError.onError = (details) => FlutterError.presentError(details);
    ErrorWidget.builder = (details) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text('An error occurred'.hardcoded),
          ),
          body: Center(child: Text(details.toString())),
        );
  }, (error, _) => debugPrint(error.toString()));
}
