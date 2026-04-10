import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'game/cosmic_collector_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GameWidget.controlled(gameFactory: StarCollectorGame.new));
}