import 'dart:async';

import 'package:flutter/material.dart';
import 'spielwiesn_context.dart';
import 'spielwiesn_app.dart';

void main() {
  initializeContext();

  FlutterError.onError = (FlutterErrorDetails details) {
    talker.handle(details.exception, details.stack);
  };

  runZonedGuarded(
    () {
      runApp(const SpielwiesnApp());
    },
    (error, stackTrace) {
      talker.handle(error, stackTrace);
    },
  );
}
