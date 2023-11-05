import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_svg/flame_svg.dart';
// import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:vector_graphics/src/listener.dart';
import '../logger.dart';
import '../websocket/simulation_api.dart';

// TAKEN FROM
// https://pub.dev/packages/flame/example

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
class SimVisualiser extends FlameGame with TapCallbacks {
  bool isAdded = false;
  int carCount = 0;
  var cars = <Car>[];
  BuildContext context;

  SimVisualiser({required this.context});

  @override
  Future<void> onLoad() async {
    if (!isAdded) {
      SimulationAPI.addMessageListener(onMessage);
      isAdded = true;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.canvasPosition;
      var car = Car(carCount.toString(), math.pi / 2, touchPoint);
      add(car);
      cars.add(car);
      carCount++;
      event.handled = true;
    }
  }

  @override
  Color backgroundColor() => Theme.of(context).colorScheme.background;

  // add a rectangle to the screen
  // x value is the message's value * Square.Size * 2
  void onMessage(dynamic message) {
    final x = double.parse(message) * Square.squareSize;
    // add 1 to each car's x position
    for (final car in cars) {
      car.addToPosition(Vector2(x, 0));
    }
  }
}

class Car extends SvgComponent {
  // meta data
  String id;
  static final Paint yellow = BasicPalette.yellow.paint();

  // svg instance
  // late SvgComponent carSVG;

  // car pos and heading
  // Vector2 position;
  double heading;

  Car(this.id, this.heading, Vector2 position)
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
    l.i('Car: "$id"');
  }

  Future<Svg> loadSvg(String svg) async {
    return await Svg.load(svg);
  }

  void updatePosition(Vector2 position) {
    this.position = position;
  }

  void addToPosition(Vector2 position) {
    this.position += position;
  }
}

class Square extends RectangleComponent with TapCallbacks {
  static const speed = 3;
  static const squareSize = 20.0;
  static const indicatorSize = 6.0;

  static final Paint red = BasicPalette.red.paint();
  static final Paint blue = BasicPalette.blue.paint();

  Square(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(squareSize),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    angle += speed * dt;
    angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    removeFromParent();
    event.handled = true;
  }
}
