import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

// ╒══════════════════════════════════════════════════════════════════════════════╕
// │                              🚗 Car Component                              │
// ╘══════════════════════════════════════════════════════════════════════════════╛
// CarComponent is a Flame Engine Component
// Based on the SvgComponent, such that it can be instantiated from an svg file
// The component reflects the position and heading of the car
class CarComponent extends SvgComponent {
  // meta data
  String id;
  double heading;
  static final Paint yellow = BasicPalette.yellow.paint();

  CarComponent({required this.id, required Vector2 position, required this.heading})
      : super(
          position: position,
          size: Vector2.all(100),
          anchor: Anchor.center,
          scale: Vector2.all(.5),
          angle: heading,
          paint: yellow,
        ) {
    loadSvg("svg/car.svg").then((value) {
      svg = value;
    });
  }

  Future<Svg> loadSvg(String svg) async {
    return await Svg.load(svg);
  }

  void updatePosition(Vector2 position) {
    this.position = position;
  }

  void updateHeading(double heading) {
    angle = heading;
  }

  void addToPosition(Vector2 position) {
    this.position += position;
  }
}
