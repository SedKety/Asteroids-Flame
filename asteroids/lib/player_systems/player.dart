import 'dart:async';


import 'package:asteroids/damagable.dart';
import 'package:asteroids/player_systems/mixins/TransformExtensions.dart';
import 'package:asteroids/player_systems/shooting/bullet.dart';
import 'package:asteroids/pooling/object_pool.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState{idle, flying, dashing}

//Player class, inherits from SpriteAnimationGroupComponent (instead of using base, its called super in Dart.)
//Also makes use of the "mixin" KeyboardHandler, this will allow the reading of key-inputs
  //A mixin is kind of like an interface, but it allows for code within the functions it lends.
class Player extends SpriteAnimationGroupComponent with KeyboardHandler, TransformExtensions, CollisionCallbacks implements Damagable
{
  //The late keyword: It tells the compiler that it isnt directly initialized but it will later.
  //The final keyword: Like const, but at runtime. Once assigned cannot be reassigned. Its like a lock
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation dashAnimation;

  int health = 3; //Player health

  //Movement
  double movespeed = 100; //The speed at which the player will move

  //Dashing
  bool isDashing = false; // Whether or not the player is dashing

  double dashSpeedMultiplier = 2; //The multiplier applied on speed when dashing

  double dashCooldown = 5; //Cooldown before being able to dash again

  double dashTimer = 5; //Time since last dash

  double dashDuration = 1.5; //How long the dash lasts
  double rotationDuringDashMultiplier = .33;

  //Rotation
  double rotationSpeed = 3; //Speed at which the angle of the player is set
  
  double rotationDirection = 0; //The "axis" used to determine whether to increment or decrement the angle of the object

  //Shooting
  ObjectPool bulletPool = ObjectPool<Bullet>();
  double bulletVelocity = 333;
  Vector2 shootPos = Vector2(10, -5);

  //The "awake/start" method (as it's called in unity), called upon component-instantiation.
  @override
  FutureOr<void> onLoad() async{

    priority = 1;
    //Have the bulletpool be an active entity within the game hierarchy
      //Needed to show the pooledobject-sprites
    parent!.add(bulletPool);

    idleAnimation = await SpriteAnimation.load("spaceship/spaceship.png",
      SpriteAnimationData.sequenced(amount: 1, stepTime: 10000, textureSize: Vector2(34, 26)));

     dashAnimation = await SpriteAnimation.load("spaceship/spaceship_dash.png",
      SpriteAnimationData.sequenced(amount: 16, stepTime: .025, textureSize: Vector2(34, 26)));

    //I LOVE this system, way more intuitive than the unity version (though that is made more for artists, not really for programmers).
    //"animations" acts like a filter, you pass in an enum and you get the corrosponding animation (like a dictionary in c#, KvP)
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.dashing: dashAnimation,
    };

    //This sets the current animation with the input being an enum as explained before.
    //Effectively this system is just a statemachine with enums
    current = PlayerState.dashing;


    //Sets the anchor(2D "origin") to the center of the sprite
    super.anchor = Anchor.center;
    add(RectangleHitbox(anchor: Anchor.topLeft));

  }

  
  //Standard-engine update function. "dt" stands for deltatime: time since last frame
  @override 
  void update(double dt){
    dashTimer += dt; 
    if(dashTimer >= dashDuration){
      isDashing = false;
      current = PlayerState.idle;
    }
    
    var movementVector = lookingDirection(angle) * movespeed * dt;

    //Forward translation
      //Simple ternary to decide whether or not to apply the dashSpeedMultiplier
    position += isDashing ? movementVector * dashSpeedMultiplier : movementVector; 

    //Adjust angle according to input
    angle += rotationDirection * rotationSpeed * dt;

    //Call the base update
    super.update(dt);
  }

  //Triggered when any keyboard key is interacted with (pressed, released, holding...)
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed){
    rotationDirection = 0;

    if(keysPressed.contains(LogicalKeyboardKey.space)){
      shoot();
    }
    
    if(keysPressed.contains(LogicalKeyboardKey.keyW)){
      if(dashCooldown <= dashTimer){
        isDashing = true;
        dashTimer = 0;
        current = PlayerState.dashing;
      }
    }

    if(keysPressed.contains(LogicalKeyboardKey.keyA)){
      rotationDirection--;
    }

    if(keysPressed.contains(LogicalKeyboardKey.keyD)){
      rotationDirection++;
    }

    if(isDashing) {
      rotationDirection *= rotationDuringDashMultiplier;
    }

    return true;
  }
  
  Vector2 rotatedShootPos(Vector2 shootPos, double angle) => shootPos.clone()..rotate(angle);

  void shoot(){

    var bulletPos = position + rotatedShootPos(shootPos, angle);

    //Tries to de-pool an existing (but disabled) bullet. 
    var bullet = bulletPool.depoolItem();

    //If succesfull simply update its values
    if(bullet != null){
      bullet.updateValues(bulletPos, angle, bulletPool);
    }
    //If unsuccesfull create another bullet and add it to the bulletpool
    else{
    bullet = Bullet(position: bulletPos, bulletVelocity: bulletVelocity, angle: angle, bulletPoolSource: bulletPool);
    bulletPool.add(bullet);
    }
  }

  @override
  void takeDamage(int amount, DamageLayer damageLayer){
    print("Player has been hit");
    //If we somehow manage to attack ourselves the damage gets nullified
    if(damageLayer == DamageLayer.friendly) return;

    health -= amount;
    if(health <= 0){ 
      onDeath(); 
    }
  }

  void onDeath(){
    print("Player has died");
  }
}