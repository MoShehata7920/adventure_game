import 'package:adventure_game/adventure.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  AdventureGame game = AdventureGame();

  runApp(GameWidget(game: kDebugMode ? AdventureGame() : game));
}
