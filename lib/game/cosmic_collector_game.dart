import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/foundation.dart';

import 'app_text_styles.dart';
import 'components/enemy.dart';
import 'components/player.dart';
import 'components/star.dart';
import 'constants.dart';

/// The top-level Flame game class for Cosmic Collector.
///
/// Responsibilities:
/// - Owns and orchestrates all game state ([score], [gameOver]).
/// - Manages the game loop (star spawn timer).
/// - Handles tap input to move the player or restart after game-over.
/// - Exposes [onStarCollected] and [endGame] as the sole public API that
///   components call back into, keeping coupling minimal.
///
/// [HasCollisionDetection] is required for Flame's hitbox/callback system
/// used by [Star], [Enemy], and [Player].
class StarCollectorGame extends FlameGame
    with TapDetector, HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player;

  /// Current score. Increases by 10 for each collected star.
  int score = 0;

  /// Whether the game has ended. Components read this to guard their update.
  bool gameOver = false;

  /// Shared [math.Random] instance for all components.
  ///
  /// A single instance is reused across the game to avoid allocating a new
  /// [math.Random] on every spawn/collision call.
  final math.Random random = math.Random();

  late TextComponent _scoreText;
  late TextComponent _gameOverText;

  double _starSpawnTimer = 0;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.visibleGameSize = size;

    player = Player();
    add(player);

    _scoreText = TextComponent(
      text: '${GameConstants.scorePrefix}0',
      position: Vector2(GameConstants.scoreTextX, GameConstants.scoreTextY),
      textRenderer: buildScoreRenderer(),
    );
    add(_scoreText);

    _gameOverText = TextComponent(
      text: GameConstants.gameOverMessage,
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: buildGameOverRenderer(),
    );

    for (int i = 0; i < GameConstants.initialStarCount; i++) {
      _spawnStar();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameOver) {
      _starSpawnTimer += dt;
      if (_starSpawnTimer >= GameConstants.starSpawnInterval) {
        _spawnStar();
        _starSpawnTimer = 0;
      }
    }
  }

  /// Called by [Star] when the player collides with it.
  ///
  /// Increments the score and randomly spawns an [Enemy].
  void onStarCollected() {
    score += 10;
    _scoreText.text = '${GameConstants.scorePrefix}$score';

    if (random.nextDouble() < GameConstants.enemySpawnChance) {
      add(Enemy());
    }
  }

  /// Called by [Enemy] when it reaches the player.
  ///
  /// Idempotent — safe to call multiple times (guarded by [gameOver] flag).
  void endGame() {
    if (!gameOver) {
      gameOver = true;
      add(_gameOverText);
      player.removeFromParent();
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    if (gameOver) {
      _restartGame();
      return true;
    }

    player.moveTowards(info.eventPosition.global);
    return true;
  }

  /// Builds the [TextRenderer] for the score label.
  ///
  /// Override in tests to avoid triggering google_fonts asset loading.
  @visibleForTesting
  TextRenderer buildScoreRenderer() => _buildScoreRenderer();

  TextRenderer _buildScoreRenderer() => TextPaint(
        style: AppTextStyles.scoreStyle(
          fontSize: GameConstants.scoreFontSize,
        ),
      );

  /// Builds the [TextRenderer] for the game-over label.
  ///
  /// Override in tests to avoid triggering google_fonts asset loading.
  @visibleForTesting
  TextRenderer buildGameOverRenderer() => _buildGameOverRenderer();

  TextRenderer _buildGameOverRenderer() => TextPaint(
        style: AppTextStyles.gameOverStyle(
          fontSize: GameConstants.gameOverFontSize,
        ),
      );

  void _spawnStar() {
    add(
      Star(
        position: Vector2(
          random.nextDouble() *
                  (size.x - GameConstants.spawnPaddingX) +
              GameConstants.spawnMarginX,
          random.nextDouble() *
                  (size.y - GameConstants.spawnPaddingY) +
              GameConstants.spawnMarginY,
        ),
      ),
    );
  }

  void _restartGame() {
    removeAll(
      children
          .where((component) => component is Star || component is Enemy)
          .toList(),
    );

    if (_gameOverText.isMounted) {
      remove(_gameOverText);
    }

    gameOver = false;
    score = 0;
    _scoreText.text = '${GameConstants.scorePrefix}0';
    _starSpawnTimer = 0;

    player = Player();
    add(player);

    for (int i = 0; i < GameConstants.initialStarCount; i++) {
      _spawnStar();
    }
  }
}
