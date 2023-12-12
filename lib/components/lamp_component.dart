import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'lamp.dart';
import '../logger.dart';

// ╒══════════════════════════════════════════════════════════════════════════════╕
// │                          💡 Street Lamp Component                           │
// ╘══════════════════════════════════════════════════════════════════════════════╛
// flame game lamp component extending circle component
class LampComponent extends CircleComponent with TapCallbacks {
  Lamp lamp;
  late CircleComponent? glow;

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
        ) {
    final bigRadius = radius * 3 * lamp.lightLevel;
    glow = CircleComponent(
      position: Vector2(-(bigRadius + radius) / 2, -(bigRadius + radius) / 2),
      radius: bigRadius,
      paint: Paint()..color = color.withOpacity(lamp.lightLevel / 2),
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (glow != null) {
      add(glow!);
    }
  }

  @override
  bool onTapDown(TapDownEvent event) {
    l.d("Tapped on lamp ${lamp.id}\nWith event: $event");
    return true;
  }

  void fadeOpacityTo(double opacity, {double? duration}) async {
    add(
      OpacityEffect.to(
        opacity,
        EffectController(
          duration: duration ?? 0.5,
        ),
      ),
    );
    final double glowOpacity = opacity > 0 ? lamp.lightLevel / 2 : 0;
    add(
      OpacityEffect.to(
        glowOpacity,
        EffectController(
          duration: duration ?? 0.5,
        ),
        target: glow!,
      ),
    );
  }
}
