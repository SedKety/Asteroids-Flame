import 'dart:math';

import 'package:asteroids/asteroid_game.dart';
import 'package:asteroids/asteroid_systems/asteroid.dart';
import 'package:asteroids/pooling/object_pool.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class AsteroidSpawner extends Component with HasGameReference<AsteroidsGame> {

  ObjectPool asteroidPool = ObjectPool<Asteroid>();

  Random random = Random();

  double spawnInterval = 2;
  double timeSinceLastSpawn = 0;

  int maxAsteroids = 25;

  double distanceFromPlayer = 333;

  @override
  void onLoad(){
    game.add(asteroidPool);
  }

  @override
  void update(double dt){
    timeSinceLastSpawn += dt;
    if(timeSinceLastSpawn >= spawnInterval){
      timeSinceLastSpawn = 0;
      spawnAsteroid();
    }
  }

  void spawnAsteroid() async{
    int attempts = 10; //The maximum amount of tries to spawn an asteroid far enough from the player

    var asteroid = asteroidPool.depoolItem();

    late Vector2 spawnPos;
    bool posFound = false;

    //Find an valid position to spawn an asteroid, away from the player but inside the screen
    for(int i = 0; i < attempts; i++){
      spawnPos = Vector2(random.nextDouble() * game.size.x, random.nextDouble() * game.size.y);

      if(spawnPos.distanceTo(game.player.position) >= distanceFromPlayer){
        print(spawnPos.distanceTo(game.player.position));
        posFound = true;
        break;
      }
    }

    //If no valid position is found far away enough from the player we return to prevent spawning an asteroid on the player
    if(!posFound) return; 

    var velocity = Vector2(random.nextDoubleBetween(-1, 1) * 50, random.nextDouble() * 50);

    if(asteroid != null){
      asteroid.updateValues(spawnPos, velocity, asteroidPool, 0);
    }
    else{
      asteroid = Asteroid(position: spawnPos, gameRef: game, asteroidVelocity: velocity, pool: asteroidPool, level: 0);
      asteroid.parent = asteroidPool;
    }
  }

}