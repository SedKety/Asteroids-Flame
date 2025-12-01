import 'dart:math';

import 'package:asteroids/asteroid_game.dart';
import 'package:asteroids/asteroid_systems/asteroid.dart';
import 'package:asteroids/pooling/object_pool.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class AsteroidSpawner extends Component with HasGameReference<AsteroidsGame> {

  ObjectPool asteroidPool = ObjectPool<Asteroid>();

  Random random = Random();

  double spawnInterval = 2;
  double timeSinceLastSpawn = 0;

  int maxAsteroids = 25;

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
    var asteroid = asteroidPool.depoolItem();
    var spawnPos = new Vector2(random.nextDouble() * game.size.x, random.nextDouble() * game.size.y);
    var velocity = Vector2(random.nextDouble() * 50, random.nextDouble() * 50);
    var angle = random.nextDouble();
    if(asteroid != null){
      asteroid.updateValues(spawnPos, angle, velocity, asteroidPool);
    }
    {
      asteroid = Asteroid(position: spawnPos, gameRef: game, asteroidVelocity: velocity, pool: asteroidPool);
    }
    asteroidPool.add(asteroid);
  }
}