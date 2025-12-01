import 'dart:math';

import 'package:asteroids/damagable.dart';
import 'package:asteroids/player_systems/mixins/transform_extensions.dart';
import 'package:asteroids/pooling/object_pool.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Asteroid extends SpriteComponent with CollisionCallbacks, TransformExtensions implements Damagable {

  Game game;
  Vector2 velocity;
  ObjectPool asteroidPool;
  double rotationSpeed = 1; 

  //Splitting logic
  int currentSplitLevel = 0; //The count of cycles this asteroid has lived.
  int maxSplitLevel = 2;  //How many cycles this asteroid can live
  int fragments = 2; //How many split asteroids are spawned. Nicknamed: Fragments

  Asteroid({required Vector2 position, 
    required Game gameRef, 
    required Vector2 asteroidVelocity, 
    required ObjectPool pool, 
    required int level
    }) : game = gameRef, velocity = asteroidVelocity, asteroidPool = pool, currentSplitLevel = level,
      super(position: position, size: Vector2(124, 70));

  void updateValues(Vector2 updatedPosition, Vector2 updatedVelocity, ObjectPool OP, int level){
    position = updatedPosition;
    velocity = updatedVelocity;
    asteroidPool = OP;
    currentSplitLevel = level;

    OP.add(this);
    scaleAsteroid();
  }

  @override
  Future<void> onLoad() async { 
    priority = 2;
    Random random = Random();
    sprite = await Sprite.load("asteroids/asteroid_${random.nextInt(6)}.png");
    scaleAsteroid();
    
    super.anchor = Anchor.center;
    add(RectangleHitbox(anchor: Anchor.topLeft));

  }

  @override 
  void update(double dt){
    angle += rotationSpeed * dt;
    position += velocity * dt;
    wrapAroundScreen(game, position);
  }

  //The base size of the sprite
  final Vector2 baseSize = Vector2(124, 70);
  void scaleAsteroid() =>
    size = baseSize * pow(0.67, currentSplitLevel).toDouble();


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    onCollisionCallback?.call(intersectionPoints, other);
    if (other is Damagable) {
      final d = other as Damagable;
      if(d.takeDamage(1, DamageLayer.enemy)){
        onDestroy();
      }
   }
    super.onCollision(intersectionPoints, other);
  }

  void onDestroy(){
    print("Destroyed");
    asteroidPool.poolItem(this);
    removeFromParent();

    if(currentSplitLevel < maxSplitLevel){
      split();
    }
  }

  void split(){
    for(int i = 0; i < fragments; i++){
      spawnFragment();
    }
  }

  @override
  bool takeDamage(int value, DamageLayer layer){
    if(layer == DamageLayer.enemy) return false;
    onDestroy();
    return true;
  }

  void spawnFragment() async{
    var random = Random();
    var asteroid = asteroidPool.depoolItem();
    var spawnPos = Vector2(position.x, position.y);
    var velocity = Vector2(random.nextDouble() * 50, random.nextDouble() * 50);

    if(asteroid != null){
      asteroid.updateValues(spawnPos, velocity, asteroidPool, currentSplitLevel + 1);
    }
    else{
      asteroid = Asteroid(position: spawnPos, gameRef: game, asteroidVelocity: velocity, pool: asteroidPool, level: currentSplitLevel + 1);
      asteroid.parent = asteroidPool;
    }
  }

}

