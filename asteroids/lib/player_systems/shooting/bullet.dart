import 'package:asteroids/damagable.dart';
import 'package:asteroids/pooling/object_pool.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:asteroids/player_systems/mixins/transform_extensions.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';

enum BulletState { alive, destroyed }

class Bullet extends SpriteAnimationGroupComponent
    with TransformExtensions, CollisionCallbacks {
  double velocity = 0; //How fast the bullet moves

  double despawnTime =
      5; //For how long the bullet can exist before having the onDestroy function
  double lifetimeCounter = 0; //For how long the bullet is active

  ObjectPool bulletPool;

  Game game;
  Bullet({
    required final Vector2 position,
    required final double bulletVelocity,
    required final double angle,
    required final bulletPoolSource,
    required final gameRef,
  }) : velocity = bulletVelocity,
       bulletPool = bulletPoolSource,
       game = gameRef,
       super(angle: angle, position: position);

  void updateValues(
    Vector2 updatedPosition,
    double updatedAngle,
    ObjectPool OP,
  ) {
    position = updatedPosition;
    angle = updatedAngle;
    bulletPool = OP;
    parent = OP;
    lifetimeCounter = 0;
  }

  @override
  void onLoad() async { 

    priority = 2;
    add(RectangleHitbox());
    parent = bulletPool;
    var alive = await SpriteAnimation.load(
      "projectiles/plasma_bolt.png",
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 10000,
        textureSize: Vector2(230, 80),
      ),
    );

    scale *= .1;

    //Allows for an bullet explosion animation if enough time remains
    animations = {BulletState.alive: alive, BulletState.destroyed: alive};
    current = BulletState.alive;

    //My implementation of the required Flame effects
    final pulseEffect = SequenceEffect([
      ScaleEffect.to(Vector2.all(.2), EffectController(duration: 0.2)),
      ScaleEffect.to(Vector2.all(0.10), EffectController(duration: 0.2)),
    ], infinite: true);

    add(pulseEffect);
  }

  @override
  void update(double dt) {
    lifetimeCounter += dt;
    if (lifetimeCounter >= despawnTime) {
      onDestroy();
    }

    position += lookingDirection(angle) * velocity * dt;

    wrapAroundScreen(game, position);

    super.update(dt);
  }

  void onDestroy() {
    bulletPool.poolItem(this);
    removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    onCollisionCallback?.call(intersectionPoints, other);
    if (other is Damagable) {
      var d = other as Damagable;
      if (d.takeDamage(1, DamageLayer.friendly)) {
        onDestroy();
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
