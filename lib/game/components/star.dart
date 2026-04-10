import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../cosmic_collector_game.dart';
import 'player.dart';

/// A collectible star component.
///
/// Rotates continuously and notifies the game via [StarCollectorGame.onStarCollected]
/// when the player touches it. Collision detection uses Flame's [CollisionCallbacks]
/// system (a [CircleHitbox] is added in [onLoad]) — the manual distance-math
/// approach from the original has been replaced.
///
/// The star polygon [Path] is pre-computed once in [onLoad] and reused every
/// render frame to avoid per-frame path construction overhead.
class Star extends PositionComponent
    with HasGameReference<StarCollectorGame>, CollisionCallbacks {
  Star({required super.position});

  /// Rotation speed in radians/second, randomised per star.
  late final double _rotationSpeed;

  /// Pre-built 5-point star polygon reused every frame.
  late final Path _starPath;

  // Created once in the field initializer, never re-allocated per frame.

  final Paint _fillPaint = Paint()
    ..color = Colors.yellow
    ..style = PaintingStyle.fill;

  final Paint _borderPaint = Paint()
    ..color = Colors.orange
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  Future<void> onLoad() async {
    size = Vector2.all(GameConstants.starSize);
    anchor = Anchor.center;

    _rotationSpeed = GameConstants.starMinRotationSpeed +
        game.random.nextDouble() *
            (GameConstants.starMaxRotationSpeed -
                GameConstants.starMinRotationSpeed);

    // Pre-compute star polygon — only runs once per star instance.
    _starPath = _buildStarPath();

    add(CircleHitbox());
  }

  /// Builds the 5-point star [Path] centred within the component's [size].
  Path _buildStarPath() {
    const double outerRadius = GameConstants.starOuterRadius;
    const double innerRadius = outerRadius * GameConstants.starInnerRadiusFactor;
    const int points = GameConstants.starPoints;

    final Path path = Path();
    for (int i = 0; i < points * 2; i++) {
      final double theta = (i * math.pi) / points;
      final double radius = i.isEven ? outerRadius : innerRadius;
      final double x = size.x / 2 + radius * math.cos(theta - math.pi / 2);
      final double y = size.y / 2 + radius * math.sin(theta - math.pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      // Delegate scoring and optional enemy spawn to the game orchestrator.
      game.onStarCollected();
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += _rotationSpeed * dt;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawPath(_starPath, _fillPaint);
    canvas.drawPath(_starPath, _borderPaint);
  }
}
