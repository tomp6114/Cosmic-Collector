/// Centralized constants for the Cosmic Collector game.
///
/// All magic numbers, magic strings, and configuration values are defined here.
/// Never reference bare literals in game logic — use these constants instead.
class GameConstants {
  // Private constructor — this class is not meant to be instantiated.
  GameConstants._();

  /// Movement speed of the player in logical pixels per second.
  static const double playerSpeed = 200.0;

  /// Diameter of the player circle hitbox.
  static const double playerSize = 30.0;

  /// Distance threshold below which the player stops moving to a target.
  static const double playerStopThreshold = 5.0;

  /// Diameter of each star component.
  static const double starSize = 25.0;

  /// Minimum rotation speed in radians per second.
  static const double starMinRotationSpeed = 1.0;

  /// Maximum rotation speed in radians per second.
  /// Original used `Random().nextDouble() * 4 + 1` → range [1, 5).
  static const double starMaxRotationSpeed = 5.0;

  /// Outer (tip) radius of the star polygon.
  static const double starOuterRadius = starSize / 2;

  /// Ratio of inner radius to outer radius for the star polygon.
  static const double starInnerRadiusFactor = 0.4;

  /// Number of points on the star polygon.
  static const int starPoints = 5;

  /// Probability [0, 1] that collecting a star spawns an enemy.
  static const double enemySpawnChance = 0.3;

  /// Diameter of each enemy component.
  static const double enemySize = 25.0;

  /// Movement speed of enemies in logical pixels per second.
  static const double enemySpeed = 100.0;

  /// Off-screen buffer distance (px) before an enemy is removed.
  static const double enemyOffscreenBuffer = 100.0;

  /// Number of stars placed when the game (re)starts.
  static const int initialStarCount = 3;

  /// Seconds between automatic star spawns during gameplay.
  static const double starSpawnInterval = 1.5;

  /// Minimum horizontal padding from screen edge for spawned stars (px).
  static const double spawnMarginX = 20.0;

  /// Minimum vertical padding from screen top for spawned stars (px).
  static const double spawnMarginY = 50.0;

  /// Total horizontal area excluded from spawn zone (both edges combined, px).
  static const double spawnPaddingX = 40.0;

  /// Total vertical area excluded from spawn zone (top + bottom combined, px).
  static const double spawnPaddingY = 100.0;

  /// Prefix string rendered before the numeric score value.
  static const String scorePrefix = 'Score: ';

  /// Message displayed when the game ends.
  static const String gameOverMessage = 'Game Over! Tap to restart';

  /// Font size for the score text component.
  static const double scoreFontSize = 24.0;

  /// Font size for the game-over text component.
  static const double gameOverFontSize = 32.0;

  /// Horizontal position of the score text component (px from left).
  static const double scoreTextX = 170.0;

  /// Vertical position of the score text component (px from top).
  static const double scoreTextY = 50.0;
}
