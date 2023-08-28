import 'package:adventure_game/adventure.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  AdventureGame game = AdventureGame();

  runApp(GameWidget(game: game));
}
