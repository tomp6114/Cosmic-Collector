import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../cosmic_collector_game.dart';

/// The player-controlled character.
///
/// Moves toward a tap target at [GameConstants.playerSpeed] px/s and stops
/// when within [GameConstants.playerStopThreshold] px of the target.
///
/// Uses Flame's collision system — a [CircleHitbox] is registered in [onLoad].
/// Collision *responses* are handled by the components that collide with the
/// player (see [Star] and [Enemy]).
class Player extends PositionComponent
    with HasGameReference<StarCollectorGame>, CollisionCallbacks {
  /// Tap target the player is currently moving towards.
  Vector2? _targetPosition;
  // Paint objects are created once and reused every render frame to avoid
  // per-frame heap allocations and GC pressure.

  final Paint _bodyPaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.fill;

  final Paint _centerPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  @override
  Future<void> onLoad() async {
    size = Vector2.all(GameConstants.playerSize);
    position = Vector2(game.size.x / 2, game.size.y / 2);
    anchor = Anchor.center;

    add(CircleHitbox());
  }

  /// Sets the movement target to [target].
  void moveTowards(Vector2 target) {
    _targetPosition = target;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_targetPosition != null) {
      final Vector2 direction = _targetPosition! - position;
      final double distance = direction.length;

      if (distance > GameConstants.playerStopThreshold) {
        direction.normalize();
        position += direction * GameConstants.playerSpeed * dt;
      } else {
        _targetPosition = null;
      }
    }

    position.x = position.x.clamp(
      size.x / 2,
      game.size.x - size.x / 2,
    );
    position.y = position.y.clamp(
      size.y / 2,
      game.size.y - size.y / 2,
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      _bodyPaint,
    );

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 4,
      _centerPaint,
    );
  }
}
