import 'dart:math' as math;
import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_svg/flame_svg.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../logger.dart';
import '../websocket/simulation_api.dart';
import '../misc/network_converter.dart';
import 'package:cbor/cbor.dart';

/// This is a visualiser for the simulation.
/// Receiving the simulation data from the a websocket,
/// through the SimulationAPI interface.
/// - Cars will be visualised, and move
/// - Roads will be drawn
/// - Street lamps will be drawn and show their status
class SimVisualiser extends FlameGame
    with TapCallbacks, KeyboardEvents, ScrollDetector, ScaleDetector, PanDetector {
  bool _initialised = false;
  final double _zoomSensitivity = 0.001;
  late final startingPosition = Vector2.zero();
  late final PositionComponent _cameraTarget = PositionComponent(position: Vector2.zero());
  final _cars = <CarComponent>[];

  // all roads and junctions
  final _roads = <PolygonComponent>[];
  final _junctions = <PolygonComponent>[];

  late final Color _roadColor;
  late final Color _junctionColor;

  // there is buildContext in FlameGame, but it's private, and no setter
  // so we have to make our own
  BuildContext? context;

  @override
  Future<void> onLoad() async {
    if (!_initialised) {
      SimulationAPI.addMessageListener(_manageCarsOnMessage);
      initialiseCamera();
      setColors();
      await initialiseNetwork();
      _initialised = true;
      // debugMode = true;
    }
  }

  // ╒════════════════════════════════════════════════════════════════════════════╕
  // │                          🌍 Scene Initialisation                         │
  // ╘════════════════════════════════════════════════════════════════════════════╛

  void initialiseCamera() {
    // Initialise the camera to follow the the vector _cameraTarget,
    // such that when _cameraTarget moves, the camera follows
    camera = CameraComponent(world: world)..viewfinder.zoom = 0.1;
    _cameraTarget.position = Vector2(5000, 5000);
    camera.follow(_cameraTarget);
    add(camera);
  }

  void setColors() {
    if (context != null) {
      _roadColor = Theme.of(context!).colorScheme.primary;
      _junctionColor = Theme.of(context!).colorScheme.primary;
    } else {
      l.w("context is null");
      _roadColor = const Color.fromARGB(255, 127, 127, 127);
      _junctionColor = const Color.fromARGB(255, 127, 127, 127);
    }
  }

  // Initialise the network
  Future<void> initialiseNetwork() async {
    // Add the network to the world
    var (roads, junctions) = await NetworkUtils.createPolygonsFromJson("assets/json/network.json");

    // Color the roads and junctions
    for (var road in roads) {
      // l.w("road: $road");
      road.paint = Paint()..color = _roadColor;
    }
    for (var junction in junctions) {
      // l.w("junction: $junction");
      junction.paint = Paint()..color = _junctionColor;
    }

    // Load the roads and junctions from the JSON file
    _roads.addAll(roads);
    _junctions.addAll(junctions);

    // Add the roads and junctions to the world
    world.addAll(_roads);
    world.addAll(_junctions);
  }

  // ╒════════════════════════════════════════════════════════════════════════════╕
  // │                            🎥 Camera Controls                            │
  // ╘════════════════════════════════════════════════════════════════════════════╛

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

  void setZoom(double zoom, {double min = 0.05, double max = 3}) {
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

  // ╒════════════════════════════════════════════════════════════════════════════╕
  // │                           ⬅️ Message Callbacks                           │
  // ╘════════════════════════════════════════════════════════════════════════════╛

  // Instantiate cars if they don't already exist.
  // Update car positions if they do exist.
  // Remove cars that don't exist anymore.
  var lastCallTime = DateTime.now();
  void _manageCarsOnMessage(dynamic message) {
    var deltaTime = DateTime.now().difference(lastCallTime);
    if (deltaTime.inMilliseconds < 100) {
      return;
    }
    // var decodedMessage = json.decode(message);
    // var jsonMessage = message.toJson();

    // looking through existing cars in the world
    for (final car in _cars) {
      var carData = message[car.id];

      // for all cars that do already exist,
      // update their position and heading
      if (carData != null) {
        car.updatePosition(
          Vector2(
            preprocessCoordinate(carData['x']),
            preprocessCoordinate(carData['y']),
          ),
        );
        car.updateHeading((carData['heading'] as num) + math.pi / 2);
      } else {
        // when carData is null,
        // the car is not part of the received message,
        // and should therefore be removed
        l.w("removing car: ${car.id}");
        remove(car);
        _cars.remove(car);
      }

      // then remove them from the message,
      // such that they are not instantiated again
      message.remove(car.id);
    }

    // instantiate cars that don't exist yet.
    message.forEach((key, value) {
      l.w("adding car: $key");
      addCar(
        id: key,
        position: Vector2(
          preprocessCoordinate(value['x']),
          preprocessCoordinate(value['y']),
        ),
        heading: value['heading'],
      );
    });
  }

  double preprocessCoordinate(dynamic coordinate) {
    return (coordinate as num).toDouble() / NetworkUtils.parentSize.x;
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
