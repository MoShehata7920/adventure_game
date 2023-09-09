import 'dart:async';
import 'package:adventure_game/adventure.dart';
import 'package:adventure_game/components/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<AdventureGame>, CollisionCallbacks {
  Checkpoint({position, size}) : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: Vector2(19, 56),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.05, textureSize: Vector2.all(64)));
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _reachCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachCheckpoint() async {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
        SpriteAnimationData.sequenced(
          amount: 26,
          stepTime: 0.05,
          textureSize: Vector2.all(64),
          loop: false,
        ));

    await animationTicker?.completed;
    animationTicker?.reset();
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
        SpriteAnimationData.sequenced(
          amount: 10,
          stepTime: 0.05,
          textureSize: Vector2.all(64),
        ));
  }
}
