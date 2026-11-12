import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spielwiesn_spielothek/constants/app_version.dart';
import 'package:spielwiesn_spielothek/game/csv_game_list_parser.dart';
import 'package:spielwiesn_spielothek/game/game_csv_client.dart';
import 'package:spielwiesn_spielothek/game/game_repository.dart';
import 'package:spielwiesn_spielothek/game_list_view/game_list_view_controller.dart';
import 'package:spielwiesn_spielothek/main_menu/main_menu_button.dart';
import 'package:spielwiesn_spielothek/spielwiesn_context.dart';
import 'package:spielwiesn_spielothek/utils/shared_preferences_wrapper.dart';

import '../mocks/game_csv_client_mock.dart';
import '../mocks/shared_preferences_wrapper_mock.dart';

void main() {
  late GameListViewController controller;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<GameCsvClient>(GameCsvClientMock());
    getIt.registerSingleton<SharedPreferencesWrapper>(
        SharedPreferencesWrapperMock());
    getIt.registerSingleton(CsvGameListParser());
    var repository = GameRepository();
    await repository.initialize();
    getIt.registerSingleton(repository);
    controller = GameListViewController(
      showSnackBar: (message) {},
      showErrorSnackBar: (message) {},
    );
  });

  testWidgets("main menu should display the version number", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [MainMenuButton(controller: controller)],
        ),
      ),
    ));

    await tester.tap(find.byType(MainMenuButton));
    await tester.pumpAndSettle();

    expect(find.text("Version ${AppVersion.value}"), findsOneWidget);
  });
}
