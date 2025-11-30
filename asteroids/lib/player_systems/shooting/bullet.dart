import 'package:asteroids/pooling/object_pool.dart';
import 'package:flame/components.dart';
import 'package:asteroids/player_systems/mixins/TransformExtensions.dart';

enum BulletState{alive, destroyed}

class Bullet extends SpriteAnimationGroupComponent with TransformExtensions {

  double velocity = 0; //How fast the bullet moves

  double despawnTime = 2;  //For how long the bullet can exist before having the onDestroy function
  double lifetimeCounter = 0; //For how long the bullet is active

  ObjectPool bulletPool; 

  Bullet({
    required final Vector2 position,
    required final double bulletVelocity,
    required final double angle,
    required final bulletPoolSource
  }) : velocity = bulletVelocity, bulletPool = bulletPoolSource, super(angle: angle, position: position);

  void updateValues(Vector2 updatedPosition, double updatedAngle, ObjectPool OP){
    position = updatedPosition;
    angle = updatedAngle;
    bulletPool = OP;
    parent = OP;
    lifetimeCounter = 0;
  }

  @override 
  void onLoad() async{
    parent = bulletPool;
    var alive = await SpriteAnimation.load("projectiles/plasma_bolt.png",
      SpriteAnimationData.sequenced(amount: 1, stepTime: 10000, textureSize: Vector2(230, 80)));

    scale *= .1;

    //Allows for an bullet explosion animation if enough time remains
    animations = {
      BulletState.alive: alive,
      BulletState.destroyed: alive
    };
    current = BulletState.alive;
  }

  @override
  void update(double dt) {
    lifetimeCounter += dt;
    if(lifetimeCounter >= despawnTime) {
      onDestroy();
    }

    position += lookingDirection(angle) * velocity * dt;
    super.update(dt);
  }

  void onDestroy(){
    bulletPool.poolItem(this);
    removeFromParent();
  }
}