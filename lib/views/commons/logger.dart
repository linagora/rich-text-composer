import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

void log(String value, {Level level = Level.info}) {
  switch(level) {
    case Level.error:
      if (kDebugMode) {
        developer.log(value, name: 'RichTextComposer|ERROR');
      }
      break;
    case Level.info:
      if (kDebugMode) {
        developer.log(value, name: 'RichTextComposer|INFO');
      }
      break;
  }
}

void logError(String value) => log(value, level: Level.error);

enum Level {
  info,
  error
}