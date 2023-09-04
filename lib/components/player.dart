import 'dart:async';
import 'package:adventure_game/adventure.dart';
import 'package:adventure_game/components/collisions.dart';
import 'package:adventure_game/components/player_hitbox.dart';
import 'package:adventure_game/components/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<AdventureGame>, KeyboardHandler {
  Player({
    this.character = 'Ninja Frog',
    position,
  }) : super(position: position);
  String character;

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  final double _gravity = 9.8;
  final double _jumpForce = 300;
  final double _terminalVelocity = 200;

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionsBlock> collisionsBlock = [];
  PlayerHitbox hitbox =
      PlayerHitbox(offsetX: 10, offsetY: 4, width: 14, height: 20);
  bool isOnGround = false;
  bool hasJumped = false;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _sprintsAnimation('Idle', 11);
    runningAnimation = _sprintsAnimation('Run', 12);
    jumpingAnimation = _sprintsAnimation('Jump', 1);
    fallingAnimation = _sprintsAnimation('Fall', 1);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
    };

    // set current animation
    current = PlayerState.running;
  }

  SpriteAnimation _sprintsAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount, stepTime: stepTime, textureSize: Vector2.all(32)));
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || scale.x < 0) {
      playerState = PlayerState.running;
    }

    if (velocity.y > 0) {
      playerState = PlayerState.falling;
    }

    if (velocity.y < 0) {
      playerState = PlayerState.jumping;
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionsBlock) {
      if (!block.isPlatform) {
        if (checkCollisions(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + hitbox.offsetX + block.width + hitbox.width;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionsBlock) {
      if (block.isPlatform) {
        if (checkCollisions(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.offsetY - hitbox.height;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollisions(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.offsetY - hitbox.height;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
}
