import 'dart:async';
import 'dart:ui';
import 'package:adventure_game/levels/level.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';

class AdventureGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;

  final world = Level();

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    return super.onLoad();
  }
}
