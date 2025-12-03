import 'package:flame/components.dart';

class DynamicTextComponent extends TextComponent {
  late String Function() fn;

  DynamicTextComponent({
    required Vector2 pos,
    String Function()? fn, 
  }) : fn = fn ?? (() => "No func added"),
       super(position: pos);

  @override
  void update(double dt) {
    text = fn();
  }
}
