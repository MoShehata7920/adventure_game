import 'package:adventure_game/adventure.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  AdventureGame game = AdventureGame();

  runApp(GameWidget(game: kDebugMode ? AdventureGame() : game));
}
