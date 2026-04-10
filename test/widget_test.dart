import 'package:flame/text.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmic_collector_game/game/cosmic_collector_game.dart';
import 'package:cosmic_collector_game/game/constants.dart';

/// Test-only subclass that bypasses google_fonts font loading.
///
/// Overrides [_buildScoreRenderer] and [_buildGameOverRenderer] to return
/// plain [TextPaint]s backed by simple [TextStyle]s, preventing the async
/// google_fonts HTTP-fetch exception from leaking into the test runner.
class _TestableGame extends StarCollectorGame {
  @override
  TextRenderer buildScoreRenderer() => TextPaint(
        style: const TextStyle(
          color: Color.fromARGB(255, 55, 195, 62),
          fontSize: GameConstants.scoreFontSize,
          fontWeight: FontWeight.bold,
        ),
      );

  @override
  TextRenderer buildGameOverRenderer() => TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: GameConstants.gameOverFontSize,
          fontWeight: FontWeight.bold,
        ),
      );
}

void main() {
  final FlameTester<_TestableGame> tester = FlameTester(_TestableGame.new);

  group('StarCollectorGame — initial state', () {
    tester.testGameWidget(
      'starts with score of 0',
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.score, equals(0));
      },
    );

    tester.testGameWidget(
      'starts with gameOver = false',
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.gameOver, isFalse);
      },
    );

    tester.testGameWidget(
      'player is mounted on start',
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.player.isMounted, isTrue);
      },
    );
  });

  group('StarCollectorGame — onStarCollected', () {
    tester.testGameWidget(
      'increments score by 10',
      setUp: (_TestableGame game, WidgetTester _) async {
        game.onStarCollected();
      },
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.score, equals(10));
      },
    );

    tester.testGameWidget(
      'increments score cumulatively across multiple calls',
      setUp: (_TestableGame game, WidgetTester _) async {
        game.onStarCollected();
        game.onStarCollected();
      },
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.score, equals(20));
      },
    );
  });

  group('StarCollectorGame — endGame', () {
    tester.testGameWidget(
      'sets gameOver to true',
      setUp: (_TestableGame game, WidgetTester _) async {
        game.endGame();
      },
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.gameOver, isTrue);
      },
    );

    tester.testGameWidget(
      'is idempotent — calling twice keeps gameOver true',
      setUp: (_TestableGame game, WidgetTester _) async {
        game.endGame();
        game.endGame();
      },
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.gameOver, isTrue);
      },
    );

    tester.testGameWidget(
      'removes player from scene',
      setUp: (_TestableGame game, WidgetTester _) async {
        game.endGame();
        // Advance a frame so pending removals are processed.
        game.update(0);
      },
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.player.isMounted, isFalse);
      },
    );
  });

  group('StarCollectorGame — score invariant', () {
    tester.testGameWidget(
      'score does not change without collecting stars',
      setUp: (_TestableGame game, WidgetTester _) async {
        game.update(0.5);
        game.update(0.5);
      },
      verify: (_TestableGame game, WidgetTester _) async {
        expect(game.score, equals(0));
      },
    );
  });
}
