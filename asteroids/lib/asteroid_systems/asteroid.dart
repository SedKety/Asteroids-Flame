import 'dart:math';

import 'package:asteroids/damagable.dart';
import 'package:asteroids/player_systems/mixins/TransformExtensions.dart';
import 'package:asteroids/pooling/object_pool.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Asteroid extends SpriteComponent with CollisionCallbacks, TransformExtensions implements Damagable {

  Game game;
  Vector2 velocity;
  ObjectPool asteroidPool;
  double rotationSpeed = 1;

  Asteroid({required Vector2 position, required Game gameRef, required Vector2 asteroidVelocity, required ObjectPool pool}) 
  : game = gameRef, velocity = asteroidVelocity, asteroidPool = pool, super(position: position, size: Vector2(124, 70));

  void updateValues(Vector2 updatedPosition, Vector2 updatedVelocity, ObjectPool OP){
    position = updatedPosition;
    velocity = updatedVelocity;
    asteroidPool = OP;
    parent = OP;
  }

  @override
  Future<void> onLoad() async { 
    Random random = Random();
    sprite = await Sprite.load("asteroids/asteroid_${random.nextInt(6)}.png");
    //angle = random.nextDouble();
    
    super.anchor = Anchor.center;
    add(RectangleHitbox(anchor: Anchor.topLeft));

  }

  @override 
  void update(double dt){
    angle += rotationSpeed * dt;
    position += velocity * dt;
    wrapAroundScreen(game, position);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    onCollisionCallback?.call(intersectionPoints, other);
    if(other is Damagable){
      //print("Encountered an Damagable component!");
    }
    super.onCollision(intersectionPoints, other);
  }

  void onDestroy(){
    asteroidPool.poolItem(this);
    removeFromParent();
  }
  @override
  void takeDamage(int value, DamageLayer layer){
    if(layer != DamageLayer.enemy){
      onDestroy();
    }
  }
}

