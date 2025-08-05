
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(GameWidget.controlled(gameFactory: StarCollectorGame.new));
}

class StarCollectorGame extends FlameGame with TapDetector, HasKeyboardHandlerComponents {
  late Player player;
  late TextComponent scoreText;
  late TextComponent gameOverText;
  int score = 0;
  bool gameOver = false;
  double starSpawnTimer = 0;
  final double starSpawnInterval = 1.5;

  @override
  Future<void> onLoad() async {
    // Set up camera
    camera.viewfinder.visibleGameSize = size;
    
    // Create player
    player = Player();
    add(player);
    
    // Create UI
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);
    
    gameOverText = TextComponent(
      text: 'Game Over! Tap to restart',
      position: Vector2(size.x / 2, size.y / 2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.red,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    // Spawn initial stars
    for (int i = 0; i < 3; i++) {
      spawnStar();
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (!gameOver) {
      starSpawnTimer += dt;
      if (starSpawnTimer >= starSpawnInterval) {
        spawnStar();
        starSpawnTimer = 0;
      }
    }
  }
  
  void spawnStar() {
    final star = Star(
      position: Vector2(
        math.Random().nextDouble() * (size.x - 40) + 20,
        math.Random().nextDouble() * (size.y - 100) + 50,
      ),
    );
    add(star);
  }
  
  void collectStar() {
    score += 10;
    scoreText.text = 'Score: $score';
  }
  
  void endGame() {
    if (!gameOver) {
      gameOver = true;
      add(gameOverText);
      player.removeFromParent();
    }
  }
  
  @override
  bool onTapDown(TapDownInfo info) {
    if (gameOver) {
      restartGame();
      return true;
    }
    
    // Move player towards tap position
    player.moveTowards(info.eventPosition.global);
    return true;
  }
  
  void restartGame() {
    // Remove all components except UI
    removeAll(children.where((component) => 
        component is Star || component is Enemy).toList());
    
    if (gameOverText.isMounted) {
      remove(gameOverText);
    }
    
    // Reset game state
    gameOver = false;
    score = 0;
    scoreText.text = 'Score: 0';
    starSpawnTimer = 0;
    
    // Recreate player
    player = Player();
    add(player);
    
    // Spawn initial stars
    for (int i = 0; i < 3; i++) {
      spawnStar();
    }
  }
}

class Player extends PositionComponent with HasGameRef<StarCollectorGame> {
  static const double speed = 200.0;
  static const double playerSize = 30.0;
  Vector2? targetPosition;
  
  @override
  Future<void> onLoad() async {
    size = Vector2.all(Player.playerSize);
    position = Vector2(gameRef.size.x / 2, gameRef.size.y / 2);
    anchor = Anchor.center;
  }
  
  void moveTowards(Vector2 target) {
    targetPosition = target;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (targetPosition != null) {
      final direction = targetPosition! - position;
      final distance = direction.length;
      
      if (distance > 5) {
        direction.normalize();
        position += direction * speed * dt;
      } else {
        targetPosition = null;
      }
    }
    
    // Keep player within screen bounds
    position.x = position.x.clamp(size.x / 2, gameRef.size.x - size.x / 2);
    position.y = position.y.clamp(size.y / 2, gameRef.size.y - size.y / 2);
  }
  
  @override
  void render(Canvas canvas) {
    // Draw player as a blue circle
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 2,
      paint,
    );
    
    // Draw white center
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 4,
      centerPaint,
    );
  }
}

class Star extends PositionComponent with HasGameRef<StarCollectorGame>, CollisionCallbacks {
  static const double starSize = 25.0;
  double rotationSpeed = 2.0;
  
  Star({required Vector2 position}) {
    this.position = position;
    rotationSpeed = math.Random().nextDouble() * 4 + 1;
  }
  
  @override
  Future<void> onLoad() async {
    size = Vector2.all(starSize);
    anchor = Anchor.center;
    
    // Add collision detection
    add(RectangleHitbox());
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Rotate the star
    angle += rotationSpeed * dt;
    
    // Check collision with player
    if ((position - gameRef.player.position).length < (starSize + Player.playerSize) / 2) {
      gameRef.collectStar();
      removeFromParent();
      
      // Occasionally spawn an enemy
      if (math.Random().nextDouble() < 0.3) {
        gameRef.add(Enemy());
      }
    }
  }
  
  @override
  void render(Canvas canvas) {
    // Draw star shape
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    
    final path = Path();
    const double outerRadius = starSize / 2;
    const double innerRadius = outerRadius * 0.4;
    const int points = 5;
    
    for (int i = 0; i < points * 2; i++) {
      final double angle = (i * math.pi) / points;
      final double radius = i.isEven ? outerRadius : innerRadius;
      final double x = size.x / 2 + radius * math.cos(angle - math.pi / 2);
      final double y = size.y / 2 + radius * math.sin(angle - math.pi / 2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Draw border
    final borderPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawPath(path, borderPaint);
  }
}

class Enemy extends PositionComponent with HasGameRef<StarCollectorGame> {
  static const double enemySize = 25.0;
  static const double speed = 100.0;
  
  @override
  Future<void> onLoad() async {
    size = Vector2.all(enemySize);
    position = Vector2(
      math.Random().nextBool() ? -enemySize : gameRef.size.x + enemySize,
      math.Random().nextDouble() * gameRef.size.y,
    );
    anchor = Anchor.center;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Move towards player
    final direction = gameRef.player.position - position;
    if (direction.length > 0) {
      direction.normalize();
      position += direction * speed * dt;
    }
    
    // Check collision with player
    if ((position - gameRef.player.position).length < (enemySize + Player.playerSize) / 2) {
      gameRef.endGame();
    }
    
    // Remove if too far from screen
    if (position.x < -100 || position.x > gameRef.size.x + 100 ||
        position.y < -100 || position.y > gameRef.size.y + 100) {
      removeFromParent();
    }
  }
  
  @override
  void render(Canvas canvas) {
    // Draw enemy as a red triangle
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(size.x / 2, 0);
    path.lineTo(0, size.y);
    path.lineTo(size.x, size.y);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Draw border
    final borderPaint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawPath(path, borderPaint);
  }
}