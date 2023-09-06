import 'dart:async';
import 'package:adventure_game/components/player.dart';
import 'package:adventure_game/components/level.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

class AdventureGame extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  late JoystickComponent joyStick;
  bool showJoyStick = true;
  List<String> levelsNames = ['level-01', 'level-02'];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // load all images into cache
    await images.loadAllImages();

    _loadLevel();

    if (showJoyStick) {
      addJoyStick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoyStick) {
      updateJoyStick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joyStick = JoystickComponent(
        knob: SpriteComponent(
            sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        )),
        background: SpriteComponent(
            sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        )),
        margin: const EdgeInsets.only(left: 32, bottom: 32));

    add(joyStick);
  }

  void updateJoyStick() {
    switch (joyStick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;

      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;

      case JoystickDirection.up:
        player.hasJumped = true;
        break;

      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelsNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more Levels
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world =
          Level(levelName: levelsNames[currentLevelIndex], player: player);

      cam = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 360);

      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
    });
  }
}
