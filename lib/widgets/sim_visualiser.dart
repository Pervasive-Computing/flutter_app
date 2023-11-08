import 'dart:math' as math;
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_svg/flame_svg.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import '../logger.dart';
import '../websocket/simulation_api.dart';

/// This is a visualiser for the simulation.
/// Receiving the simulation data from the a websocket,
/// through the SimulationAPI interface.
/// - Cars will be visualised, and move
/// - Roads will be drawn
/// - Street lamps will be drawn and show their status
class SimVisualiser extends FlameGame
    with TapCallbacks, KeyboardEvents, ScrollDetector, ScaleDetector, PanDetector {
  bool _carSimCallbackIsAdded = false;
  final double _zoomSensitivity = 0.001;
  final PositionComponent _cameraTarget = PositionComponent(position: Vector2.zero());
  final _cars = <CarComponent>[];

  // there is buildContext in FlameGame, but it's private, and no setter
  // so we have to make our own
  BuildContext? context;

  @override
  Future<void> onLoad() async {
    if (!_carSimCallbackIsAdded) {
      SimulationAPI.addMessageListener(_addCarOnMessage);
      _carSimCallbackIsAdded = true;
    }

    // Initialise the camera to follow the the vector _cameraTarget,
    // such that when _cameraTarget moves, the camera follows
    camera = CameraComponent(world: world)..viewfinder.zoom = 1.0;
    camera.follow(_cameraTarget);
    add(camera);
  }

  // Zoom camera on pinch
  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    scaleZoom(info.scale.global.x);
  }

  void scaleZoom(double scale) {
    // l.w("scaleZoom: $scale");
    // scale is [0, 1] if scaling down, > 1 if scaling up
    var zoom = camera.viewfinder.zoom + scale;
    setZoom(zoom);
  }

  // Zoom on scroll
  @override
  void onScroll(PointerScrollInfo info) {
    // Handle scroll info for zooming
    final scrollDelta = info.scrollDelta.global.y;
    scrollZoom(scrollDelta);
  }

  void scrollZoom(double difference) {
    // l.w("scrollZoom: $difference");
    var zoom = camera.viewfinder.zoom - difference * _zoomSensitivity * camera.viewfinder.zoom;
    setZoom(zoom);
  }

  void setZoom(double zoom, {double min = 0.1, double max = 3}) {
    var clampedZoom = zoom.clamp(min, max);
    camera.viewfinder.zoom = clampedZoom;
  }

  // Pan camera on mouse drag
  @override
  bool onPanUpdate(DragUpdateInfo info) {
    // Calculate the difference in position since the start of the drag
    Vector2 delta = info.delta.global.clone();
    delta.scale(-1 / camera.viewfinder.zoom);

    // Move the camera by the difference in position
    _cameraTarget.position += delta;

    return true;
  }

  @override
  Color backgroundColor() => Theme.of(context!).colorScheme.background;

  // Instantiate cars if they don't already exist.
  // Update car positions if they do exist.
  // Remove cars that don't exist anymore.
  void _addCarOnMessage(dynamic message) {
    var decodedMessage = json.decode(message);

    // looking through existing cars in the world
    for (final car in _cars) {
      var carData = decodedMessage[car.id];

      // for all cars that do already exist,
      // update their position and heading
      if (carData != null) {
        car.updatePosition(Vector2(carData['x'], carData['y']));
        car.updateHeading(carData['heading'] + math.pi / 2);
      } else {
        // when carData is null,
        // the car is not part of the received message,
        // and should therefore be removed
        remove(car);
        _cars.remove(car);
      }

      // then remove them from the message,
      // such that they are not instantiated again
      decodedMessage.remove(car.id);
    }

    // instantiate cars that don't exist yet.
    decodedMessage.forEach((key, value) {
      addCar(
        id: key,
        position: Vector2(value['x'], value['y']),
        heading: value['heading'],
      );
    });
  }

  // Instantiate a car,
  // add it to the world and to the list of cars
  void addCar({
    required String id,
    required Vector2 position,
    required double heading,
  }) {
    var car = CarComponent(
      id: id,
      position: position,
      heading: heading,
    );
    world.add(car);
    _cars.add(car);
  }
}

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
