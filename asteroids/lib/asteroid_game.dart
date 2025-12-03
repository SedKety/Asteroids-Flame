import 'dart:async';

import 'package:asteroids/asteroid_systems/asteroid_spawner.dart';
import 'package:asteroids/player_systems/player.dart';
import 'package:asteroids/ui/dynamic_text_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class AsteroidsGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  //Points the player has earned
  static int points = 0;

  late Player player;
  late AsteroidSpawner asteroidSpawner;

  late DynamicTextComponent pointDisplayText;

  late void Function() restart;

  var inputDescriptions = ["Spacebar to shoot", "W to dash", "A/D to rotate"];
  late var descriptionTexts;

  AsteroidsGame({required void Function() restartFunc}) : restart = restartFunc;

  @override
  FutureOr<void> onLoad() async {
    print("Game started");
    initialize();

    await FlameAudio.play("soundtrack.wav");
    super.onLoad();
  }

  void initialize() async {

    //Reset points to prevent carrying over points from the last game
    points = 0;
    
    player = Player();
    add(player);

    asteroidSpawner = AsteroidSpawner();
    add(asteroidSpawner);

    //Display the background image as a sprite
    var background = SpriteComponent();
    background.sprite = await Sprite.load("backgrounds/game_background.jpg");
    background.priority = -1;
    background.scale = background.scale * .5;
    background.position += Vector2(0, 15);
    add(background);


    //Display the score in the top left corner
    String updateScoreText() => "Points: $points";
    pointDisplayText = DynamicTextComponent(
      pos: Vector2(size.x - 200, 50),
      fn: updateScoreText,
    );
    pointDisplayText.size *= 5;
    add(pointDisplayText);

    descriptionTexts = List.generate(inputDescriptions.length, (i) {
      final text = TextComponent(
        text: inputDescriptions[i],
        priority: 0,
        position: Vector2(25, 25 + i * 50),
        anchor: Anchor.topLeft,
      );

      add(text);
      return text;
    });

    
  }

  void onGameFinished() {
    remove(asteroidSpawner);
    remove(player);

    Vector2 center = Vector2(size.x * .5, size.y * .5);

    pointDisplayText.position = center + Vector2(0, -100);

    TextComponent deathMessage = TextComponent(text: "You died!");
    deathMessage.position = center + Vector2(0, -150);
    add(deathMessage);

    for(int i = 0; i < descriptionTexts.length; i++){
      remove(descriptionTexts[i]);
    }

    final restartButton =
        ButtonComponent(
          onPressed: restart,
          position: Vector2(size.x * .5 + 150, size.y * .5),
          button: RectangleComponent(
            size: Vector2(200, 60),
            paint: Paint()..color = const Color.fromARGB(255, 0, 0, 0),
            anchor: Anchor.center,
          ),
          buttonDown: RectangleComponent(
            size: Vector2(200, 60),
            paint: Paint()..color = const Color.fromARGB(255, 0, 0, 0),
            anchor: Anchor.center,
          ),
          anchor: Anchor.center,
        )..add(
          TextComponent(
            text: "Restart",
            priority: 10,
            anchor: Anchor.center,
            children: [],
            
          ),
        );

    add(restartButton);
  }

  @override
  Color backgroundColor() {
    return Colors.black;
  }
}
