import 'dart:math' as math;
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flame/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
// import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
// import 'package:vector_graphics/src/listener.dart';
import '../logger.dart';
import '../websocket/simulation_api.dart';

// TAKEN FROM
// https://pub.dev/packages/flame/example

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
class SimVisualiser extends FlameGame
    with TapCallbacks, KeyboardEvents, ScrollDetector, ScaleDetector, PanDetector {
  BuildContext context;

  bool isAdded = false;
  int carCount = 0;
  double zoomSensitivity = 0.001;
  // Vector2 cameraPosition = Vector2.zero();
  // NotifyingVector2 cameraPosition = NotifyingVector2.zero();
  PositionComponent cameraTarget = PositionComponent(position: Vector2.zero());
  var cars = <Car>[];

  // Vector2 cameraPosition = Vector2.zero();
  // late CameraComponent camera;

  SimVisualiser({required this.context});

  @override
  Future<void> onLoad() async {
    if (!isAdded) {
      SimulationAPI.addMessageListener(onMessage);
      isAdded = true;
    }

    // PositionComponent target = PositionComponent(position: cameraPosition);
    camera = CameraComponent(world: world)..viewfinder.zoom = 1.0;
    camera.follow(cameraTarget);
    // camera.followVector2(cameraPosition);
    add(camera);
    // camera.followVector2(cameraPosition);
  }

  // zoom camera on pinch
  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    scaleZoom(info.scale.global.x);
  }

  void scaleZoom(double scale) {
    // l.w("scaleZoom: $scale");
    // // scale is [0, 1] if scaling down, > 1 if scaling up
    // var offset = camera.viewfinder.zoom;
    var zoom = camera.viewfinder.zoom + scale;
    setZoom(zoom);
  }

  // zoom on scroll
  @override
  void onScroll(PointerScrollInfo info) {
    // Handle scroll info for zooming
    final scrollDelta = info.scrollDelta.global.y;
    scrollZoom(scrollDelta);
    // Make sure to clamp your zoom level to prevent it from inverting or becoming too large
  }

  void scrollZoom(double difference) {
    // l.w("scrollZoom: $difference");
    var zoom = camera.viewfinder.zoom - difference * zoomSensitivity * camera.viewfinder.zoom;
    setZoom(zoom);
  }

  void setZoom(double zoom, {double min = 0.1, double max = 3}) {
    l.w("zoom: $zoom");
    var clampedZoom = zoom.clamp(min, max);
    l.w("clampedZoom: $clampedZoom");
    camera.viewfinder.zoom = clampedZoom;
  }

  // pan camera on mouse drag
  @override
  bool onPanUpdate(DragUpdateInfo info) {
    // Calculate the difference in position since the start of the drag
    Vector2 delta = info.delta.global.clone();
    delta.scale(-1 / camera.viewfinder.zoom);

    // Move the camera by the difference in position
    cameraTarget.position += delta;

    return true;
  }

  @override
  Color backgroundColor() => Theme.of(context).colorScheme.background;

  // update all existing cars
  void onMessage(dynamic message) {
    // l.i(message);
    var decodedMessage = json.decode(message);
    // l.i(decoded_message);

    for (final car in cars) {
      // l.i(decodedMessage[car.id]);
      var carData = decodedMessage[car.id];

      // remove this car's data
      decodedMessage.remove(car.id);

      // if (carData == null) {
      //   addCar(car.id, car.position);
      // }

      if (carData != null) {
        // l.i("carData['x'] = ${carData['x'].runtimeType}");

        car.updatePosition(Vector2(
          carData['x'],
          carData['y'],
        ));

        car.updateHeading(carData['heading'] + math.pi / 2);
      }
    }

    // instantiate cars that don't exist yet
    decodedMessage.forEach((key, value) {
      addCar(
          key,
          Vector2(
            value['x'],
            value['y'],
          ));
    });
  }

  void addCar(String id, Vector2 position) {
    var car = Car(id, math.pi / 2, position);
    world.add(car);
    cars.add(car);
    carCount++;
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

  void updateHeading(double heading) {
    angle = heading;
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
