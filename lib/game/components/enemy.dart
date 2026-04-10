import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../cosmic_collector_game.dart';
import 'player.dart';

/// An enemy component that chases the player and ends the game on contact.
///
/// Spawns off-screen (random left or right edge) and moves toward the player
/// at [GameConstants.enemySpeed] px/s. Collision with the player is handled via
/// Flame's [CollisionCallbacks] system — the manual distance-math approach from
/// the original has been replaced by [onCollisionStart].
///
/// The triangle [Path] and [Paint] objects are pre-computed in [onLoad] and
/// reused every render frame.
class Enemy extends PositionComponent
    with HasGameReference<StarCollectorGame>, CollisionCallbacks {
  /// Pre-built triangle path, computed once in [onLoad].
  late final Path _trianglePath;

  final Paint _fillPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

  final Paint _borderPaint = Paint()
    ..color = Colors.deepOrange
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  Future<void> onLoad() async {
    size = Vector2.all(GameConstants.enemySize);

    position = Vector2(
      game.random.nextBool()
          ? -GameConstants.enemySize
          : game.size.x + GameConstants.enemySize,
      game.random.nextDouble() * game.size.y,
    );
    anchor = Anchor.center;

    // Pre-compute triangle path — fixed relative to component size.
    _trianglePath = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(0, size.y)
      ..lineTo(size.x, size.y)
      ..close();

    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      game.endGame();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Stop processing once the game is over (player has been removed).
    if (game.gameOver) return;

    final Vector2 direction = game.player.position - position;
    if (direction.length > 0) {
      direction.normalize();
      position += direction * GameConstants.enemySpeed * dt;
    }

    final bool offLeft = position.x < -GameConstants.enemyOffscreenBuffer;
    final bool offRight =
        position.x > game.size.x + GameConstants.enemyOffscreenBuffer;
    final bool offTop = position.y < -GameConstants.enemyOffscreenBuffer;
    final bool offBottom =
        position.y > game.size.y + GameConstants.enemyOffscreenBuffer;

    if (offLeft || offRight || offTop || offBottom) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(_trianglePath, _fillPaint);
    canvas.drawPath(_trianglePath, _borderPaint);
  }
}
