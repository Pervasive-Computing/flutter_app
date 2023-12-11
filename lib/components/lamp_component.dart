import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'lamp.dart';

// ╒══════════════════════════════════════════════════════════════════════════════╕
// │                          💡 Street Lamp Component                           │
// ╘══════════════════════════════════════════════════════════════════════════════╛
// flame game lamp component extending circle component
class LampComponent extends CircleComponent {
  Lamp lamp;

  LampComponent({
    required this.lamp,
    required Vector2 position,
    double radius = 100.0,
    //color
    Color color = const Color.fromARGB(255, 244, 188, 49),
  }) : super(
          position: position,
          radius: radius,
          paint: Paint()..color = color,
        );

  void fadeOpacityTo(double opacity, {double? duration}) async {
    add(
      OpacityEffect.to(
        opacity,
        EffectController(
          duration: duration ?? 0.5,
        ),
      ),
    );
  }
}
