import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
// import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logger.dart';
import '../websocket/simulation_api.dart';
import '../misc/network_utils.dart';
import '../components/car_component.dart';
import '../components/infrastructure_component.dart';
import '../components/lamp_component.dart';
import '../components/lamp.dart';
import '../themes/catppuccin_theme.dart';

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
  // final _roads = <PolygonComponent>[];
  // final _junctions = <PolygonComponent>[];
  final _infrastructure = <InfrastructureComponent>[];
  final _lamps = <LampComponent>[];

  // late Color _roadColor;
  // late Color _junctionColor;

  // event handling
  bool _isCtrlPressed = false;

  // there is buildContext in FlameGame, but it's private, and no setter
  // so we have to make our own
  BuildContext? context;

  @override
  Future<void> onLoad() async {
    if (!_initialised) {
      SimulationAPI.addMessageListener(_manageCarsOnMessage);
      initialiseCamera();
      await initialiseNetwork();
      _initialised = true;
      // debugMode = true;
    }
    setColors();
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

  // Initialise the network
  Future<void> initialiseNetwork() async {
    // roads and junctions
    var networkComponents = await NetworkUtils.infrastructureComponentsFromXml(
      "assets/xml/net.xml",
      type: XmlType.net,
    );

    _infrastructure.addAll(networkComponents);
    // world.addAll(_infrastructure);

    // other buildings and stuff
    var otherComponents = await NetworkUtils.infrastructureComponentsFromXml(
      "assets/xml/poly.xml",
      type: XmlType.poly,
    );

    // Load the roads and junctions from the JSON file
    // _infrastructure.addAll([
    //   ...otherComponents,
    //   ...networkComponents,
    // ]);

    // Sort the infrastructure by type
    _infrastructure.sort(sortInfrastructure);
    _infrastructure.reverse();

    // Add the roads and junctions to the world
    world.addAll(_infrastructure);

    // Add the lamps to the world
    var lamps = await NetworkUtils.lampsFromXml("assets/xml/lamp.xml");
    _lamps.addAll(lamps);
    world.addAll(_lamps);
  }

  final infrastructureOrder = [
    "priority",
    "traffic_light",
    "highway.cycleway",
    "highway.footway",
    "highway.path",
    "highway.pedestrian",
    "highway.service",
    "highway.steps",
    "right_before_left",
    "dead_end",
    "internal",
    "highway.residential",
    "highway.secondary",
    "highway.tertiary",
    "highway.unclassified",
    "highway.track",
    "building",
    "shop",
    "parking",
    "sport",
    "university",
    "school",
    "amenity",
    "landuse",
    "tourism",
    "aeroway",
    "man_made",
    "farm",
    "commercial",
    "residential",
    "water",
    "natural",
    "forest",
    "leisure",
  ];

  // custom infrastructure sorting function
  int sortInfrastructure(InfrastructureComponent a, InfrastructureComponent b) {
    var aIndex = infrastructureOrder.indexOf(a.type);
    var bIndex = infrastructureOrder.indexOf(b.type);
    if (aIndex == -1) {
      aIndex = infrastructureOrder.length;
    }
    if (bIndex == -1) {
      bIndex = infrastructureOrder.length;
    }
    return aIndex.compareTo(bIndex);
  }

  // ╒════════════════════════════════════════════════════════════════════════════╕
  // │                              🎨 Colouring                               │
  // ╘════════════════════════════════════════════════════════════════════════════╛

  void setColors() {
    ThemeData? theme = context != null ? Theme.of(context!) : null;
    bool? isLight = theme != null ? theme.colorScheme.brightness == Brightness.light : null;

    for (var infrastructure in _infrastructure) {
      switch (infrastructure.type) {
        case "priority" || "traffic_light":
          if (theme != null) {
            infrastructure.paint = Paint()
              ..color = isLight!
                  ? theme.colorScheme.background.darken(0.8)
                  : theme.colorScheme.background.brighten(0.9);
          } else {
            infrastructure.paint = Paint()..color = isLight! ? Colors.white70 : Colors.black87;
          }
          break;
        case "highway.cycleway" ||
              "highway.footway" ||
              "highway.path" ||
              "highway.pedestrian" ||
              "highway.service" ||
              "highway.steps" ||
              "right_before_left" ||
              "dead_end" ||
              "internal":
          if (theme != null) {
            infrastructure.paint = Paint()
              ..color = isLight!
                  ? theme.colorScheme.background.darken(0.65)
                  : theme.colorScheme.background.brighten(0.7);
          } else {
            infrastructure.paint = Paint()..color = isLight! ? Colors.white70 : Colors.black87;
          }
          break;
        case "highway.residential" ||
              "highway.secondary" ||
              "highway.tertiary" ||
              "highway.unclassified" ||
              "highway.track":
          if (theme != null) {
            infrastructure.paint = Paint()
              ..color = isLight!
                  ? theme.colorScheme.background.darken(0.8)
                  : theme.colorScheme.background.brighten(0.9);
          } else {
            infrastructure.paint = Paint()..color = isLight! ? Colors.white70 : Colors.black87;
          }
          break;
        case "amenity":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.crust!;
          } else {
            infrastructure.paint = Paint()..color = Colors.blue;
          }
          break;
        case "building":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.lavender!;
          } else {
            infrastructure.paint = Paint()..color = Colors.green;
          }
          break;
        case "commercial":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.surface0!;
          } else {
            infrastructure.paint = Paint()..color = Colors.yellow;
          }
          break;
        case "landuse":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.teal!;
          } else {
            infrastructure.paint = Paint()..color = Colors.purple;
          }
          break;
        case "shop":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.yellow!;
          } else {
            infrastructure.paint = Paint()..color = Colors.orange;
          }
          break;
        case "parking":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.surface2!;
          } else {
            infrastructure.paint = Paint()..color = Colors.red;
          }
          break;
        case "residential":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.surface1!;
          } else {
            infrastructure.paint = Paint()..color = Colors.brown;
          }
          break;
        case "school":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.surface0!;
          } else {
            infrastructure.paint = Paint()..color = Colors.teal;
          }
          break;
        case "university":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.surface0!;
          } else {
            infrastructure.paint = Paint()..color = Colors.teal;
          }
          break;
        case "tourism":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.surface0!;
          } else {
            infrastructure.paint = Paint()..color = Colors.lime;
          }
          break;
        case "leisure":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.teal!;
          } else {
            infrastructure.paint = Paint()..color = Colors.indigo;
          }
          break;
        case "sport":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.maroon!;
          } else {
            infrastructure.paint = Paint()..color = Colors.cyan;
          }
          break;
        case "water":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.blue!;
          } else {
            infrastructure.paint = Paint()..color = Colors.cyan;
          }
          break;
        case "natural":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.green!;
          } else {
            infrastructure.paint = Paint()..color = Colors.cyan;
          }
          break;
        case "man_made":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.mauve!;
          } else {
            infrastructure.paint = Paint()..color = Colors.cyan;
          }
          break;
        case "forest":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.green!;
          } else {
            infrastructure.paint = Paint()..color = Colors.cyan;
          }
          break;
        case "farm":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.green!;
          } else {
            infrastructure.paint = Paint()..color = Colors.cyan;
          }
          break;
        case "aeroway":
          if (theme != null) {
            infrastructure.paint = Paint()..color = theme.extension<CatppuccinTheme>()!.crust!;
          } else {
            infrastructure.paint = Paint()..color = Colors.cyan;
          }
          break;
      }
    }

    // the lamps
    for (var lamp in _lamps) {
      if (theme != null) {
        lamp.paint = Paint()
          ..color = theme.extension<CatppuccinTheme>()!.yellow!.withOpacity(
                lamp.lamp.lightLevel,
              );
      } else {
        lamp.paint = Paint()
          ..color = Colors.yellow.withOpacity(
            lamp.lamp.lightLevel,
          );
      }
    }
  }

  // ╒════════════════════════════════════════════════════════════════════════════╕
  // │                            🎥 Camera Controls                            │
  // ╘════════════════════════════════════════════════════════════════════════════╛

  // Zoom camera on pinch
  double _startZoom = 0;
  @override
  void onScaleStart(ScaleStartInfo info) {
    // l.w("onScaleStart");
    _startZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    // scaleZoom(info.scale.global.x);
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      final scale = currentScale.x;
      final zoom = _startZoom * scale;
      setZoom(zoom);
    }
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

  void setZoom(double zoom, {double min = 0.01, double max = 3}) {
    var clampedZoom = zoom.clamp(min, max);
    camera.viewfinder.zoom = clampedZoom;
  }

  // Pan camera on mouse drag
  // with holding ctrl, zoom
  @override
  bool onPanUpdate(DragUpdateInfo info) {
    // check if ctrl is pressed
    if (_isCtrlPressed) {
      // if ctrl is pressed, zoom
      scaleZoom(info.delta.global.y * _zoomSensitivity);
    } else {
      // Calculate the difference in position since the start of the drag
      Vector2 delta = info.delta.global.clone();
      delta.scale(-1 / camera.viewfinder.zoom);

      // Move the camera by the difference in position
      _cameraTarget.position += delta;
    }

    return true;
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // l.w("onKeyEvent: ${event.logicalKey.keyLabel}");
    if (event.isControlPressed) {
      _isCtrlPressed = true;
    } else {
      _isCtrlPressed = false;
    }
    return KeyEventResult.ignored;
  }

  @override
  Color backgroundColor() => Theme.of(context!).colorScheme.background;

  // ╒════════════════════════════════════════════════════════════════════════════╕
  // │                           ⬅️ Message Callbacks                           │
  // ╘════════════════════════════════════════════════════════════════════════════╛

  // Instantiate cars if they don't already exist.
  // Update car positions if they do exist.
  // Remove cars that don't exist anymore.
  void _manageCarsOnMessage(dynamic message) {
    // looking through existing cars in the world
    for (final car in _cars) {
      Map<Object?, Object?>? carData = message[car.id];

      if (_cars.first == car && message.length < _cars.length) {
        l.w("message.length < _cars.length");
      }

      l.w("car with id ${car.id} has data: $carData");
      l.w("_cars.length: ${_cars.length}");

      // for all cars that do already exist,
      // update their position and heading
      if (carData != null) {
        car.updatePosition(
          Vector2(
            _preprocessCoordinate(carData['x']),
            _preprocessCoordinate(carData['y']),
          ),
        );
        car.updateHeading(_preprocessHeading(carData['heading']));
      } else {
        // when carData is null,
        // the car is not part of the received message,
        // and should therefore be removed
        l.w("removing car: ${car.id}");
        world.remove(car);
        _cars.remove(car);
      }

      // then remove them from the message,
      // such that they are not instantiated again
      message.remove(car.id);
    }

    l.d("cars to add: ${message.length}");

    // instantiate cars that don't exist yet.
    message.forEach((key, value) {
      l.w("adding car: $key");
      addCar(
        id: key,
        position: Vector2(
          _preprocessCoordinate(value['x']),
          _preprocessCoordinate(value['y']),
        ),
        heading: value['heading'],
      );
    });
  }

  double _preprocessHeading(dynamic heading) {
    heading = (heading as num).toDouble();
    return math.pi - heading * math.pi / 180;
  }

  double _preprocessCoordinate(dynamic coordinate) {
    coordinate = (coordinate as num).toDouble();
    return coordinate / NetworkUtils.parentSize.x;
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
