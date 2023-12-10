import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

// ╒══════════════════════════════════════════════════════════════════════════════╕
// │                        ⏹️ Infrastructure Component                         │
// ╘══════════════════════════════════════════════════════════════════════════════╛
// InfrastructureComponent
// wraps the flame game polygon component, and adds some meta data
class InfrastructureComponent extends PolygonComponent {
  // meta data
  String id;
  String type;
  List<String> tags = [];

  InfrastructureComponent({
    required this.id,
    required this.type,
    required this.tags,
    required List<Vector2> points,
  }) : super(points);

  // @override
  // Future<void> onLoad() async {
  //   await super.onLoad();

  //   // add effects
  // }

  void fadeColorTo(double opacity, {double? duration}) async {
    add(
      OpacityEffect.to(
        opacity,
        EffectController(
          duration: duration ?? 0.5,
        ),
      ),
    );
  }

  // void fadeOut({double? duration}) async {
  //   opacity = 1;
  //   add(
  //     OpacityEffect.fadeOut(
  //       EffectController(
  //         duration: duration ?? 0.5,
  //       ),
  //     ),
  //   );
  // }

  // void fadeIn({double? duration}) async {
  //   opacity = 0;
  //   add(
  //     OpacityEffect.fadeIn(
  //       EffectController(
  //         duration: duration ?? 0.5,
  //       ),
  //     ),
  //   );
  // }
}
