import 'dart:math';

import 'package:asteroids/damagable.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Asteroid extends SpriteComponent with CollisionCallbacks {
  Asteroid({required Vector2 position}) 
      : super(position: position, size: Vector2(124, 70));

  @override
  Future<void> onLoad() async {
    debugMode = true;
    Random random = Random();
    sprite = await Sprite.load("asteroids/asteroid_${random.nextInt(6)}.png");
    angle = random.nextDouble();
    
    add(RectangleHitbox());

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    onCollisionCallback?.call(intersectionPoints, other);
    if(other is Damagable){
      print("Hittable");
    }
  }
}

