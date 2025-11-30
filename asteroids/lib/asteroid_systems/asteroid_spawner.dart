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
    var spawnPos = new Vector2(random.nextDouble() * game.size.x, random.nextDouble() * game.size.y);
    print("Spawning asteroid at: $spawnPos");
    var asteroid = Asteroid(position: spawnPos);
    asteroidPool.add(asteroid);
  }
}