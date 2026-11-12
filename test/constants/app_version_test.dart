import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spielwiesn_spielothek/constants/app_version.dart';

void main() {
  test("AppVersion.value should match version in pubspec.yaml", () {
    String pubspecContent = File("pubspec.yaml").readAsStringSync();
    RegExpMatch? match =
        RegExp(r"^version:\s*(\S+)", multiLine: true).firstMatch(pubspecContent);

    expect(match, isNotNull);
    expect(AppVersion.value, match!.group(1));
  });
}
