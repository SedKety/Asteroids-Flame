
//So the class that inherites from Damagable can identify whether or not the damage should be applied
  //eg: friendly-> enemy, enemy -> friendly, friendly -X- friendly, enemy -X- enemy
enum DamageLayer {friendly, enemy, neutral}

//Closest thing i could find to c# interfaces. Provides a contract to any "implemented" classes.
abstract class Damagable {
  //Returns whether or not damage was taken
  bool takeDamage(int amount, DamageLayer damageLayer);
}