import 'package:flame/components.dart';
import 'package:flutter/services.dart' show Color, rootBundle;
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';
import '../components/infrastructure_component.dart';
import '../logger.dart';
import '../components/lamp.dart';
import '../components/lamp_component.dart';

// enum InfrastructureType {
//   amenity,
//   building,
//   commercial,
//   landuse,
//   shop,
//   parking,
//   residential,
//   school,
//   university,
//   tourism,
//   leisure,
//   sport
// }

enum XmlType { poly, net }

class NetworkUtils {
  static Vector2 parentSize = Vector2(0.1, -0.1);

  static Future<List<InfrastructureComponent>> infrastructureComponentsFromXml(
    String path, {
    required XmlType type,
    bool disposeOther = true,
  }) async {
    // Load the XML file
    l.d("Loading XML file from path: $path");
    XmlDocument document = await _loadXmlData(path);

    if (type == XmlType.poly) {
      // Extract the infrastucture element maps from the XML document
      l.d("Extracting element maps from XML document");
      List<Map<String, String>> elementMaps = mapsFromXml(document, "additional/poly");
      l.d("Extracted ${elementMaps.length} element maps from XML document");

      // Create and return the list of InfrastructureComponents
      l.d("Creating InfrastructureComponents from element maps");
      return infrastructureComponentsFromMaps(elementMaps);
    } else if (type == XmlType.net) {
      // Extracting the road element maps from the XML document
      l.d("Extracting road element maps from XML document");
      List<Map<String, String>> roadElementMaps = mapsFromXml(document, "net/edge/lane");
      List<Map<String, String>> edgeElementMaps = mapsFromXml(document, "net/edge");
      // transfer type attribute from edge to lane
      List<Map<String, String>> roadsToBeRemoved = [];
      for (var lane in roadElementMaps) {
        for (var edge in edgeElementMaps) {
          if (lane["id"]!.contains(edge["id"]!)) {
            String? type = edge["type"];
            if (type == null) {
              // remove the lane if it has no type
              // roadElementMaps.remove(lane);
              roadsToBeRemoved.add(lane);
              continue;
            }
            lane["type"] = type;
          }
        }
      }
      for (var road in roadsToBeRemoved) {
        roadElementMaps.remove(road);
      }

      l.d("Extracted ${roadElementMaps.length} road element maps from XML document");

      // Extracting the junction element maps from the XML document
      l.d("Extracting junction element maps from XML document");
      List<Map<String, String>> junctionElementMaps = mapsFromXml(document, "net/junction");
      l.d("Extracted ${junctionElementMaps.length} junction element maps from XML document");

      // Create and return the list of InfrastructureComponents
      l.d("Creating InfrastructureComponents from element maps");
      return infrastructureComponentsFromMaps([...roadElementMaps, ...junctionElementMaps]);
    } else {
      throw Exception("Invalid XmlType");
    }
  }

  static Future<XmlDocument> _loadXmlData(String path) async {
    // Load the XML file
    String xmlString = await rootBundle.loadString(path);
    // Decode the XML data to a Dart object
    return XmlDocument.parse(xmlString);
  }

  // creates InfrastructureComponents from XML element Maps
  // wow so much shitty logic in this cause the XML structure is very inconsistent
  static List<InfrastructureComponent> infrastructureComponentsFromMaps(
      List<Map<String, String>> elementMaps) {
    List<InfrastructureComponent> infrastructureComponents = [];

    for (var elementMap in elementMaps) {
      // get the id and type of the element
      String? id = elementMap["id"];
      String? type = elementMap["type"];
      String? roadAllow = elementMap["allow"];
      String? x = elementMap["x"];
      String? y = elementMap["y"];

      List<String>? tags;

      if (roadAllow != null) {
        // get the tags of the element
        tags = roadAllow.split(" ");
      } else {
        tags = [];
      }

      // get the shape of the element
      String? shape = elementMap["shape"];

      if (shape == null) {
        // l.w("Element with id $id has no shape");
        // l.w("Element: $elementMap");
        continue;
      }

      if (type == null) {
        l.w("Element with id $id has no type");
        l.w("Element: $elementMap");
        continue;
      }

      List<Vector2> vertices;
      if (type.contains("highway")) {
        // l.w("Element with id $id has")
        if (type == "highway.footway" ||
            type == "highway.cycleway" ||
            type == "highway.path" ||
            type == "highway.pedestrian" ||
            type == "highway.steps") {
          vertices = _pathStringToVertices(shape, width: 10, expand: 0.15);
        } else {
          vertices = _pathStringToVertices(shape, width: 16, expand: 0.15);
        }
      } else {
        if (x == null || y == null) {
          vertices = _shapeStringToVertices(shape);
        } else {
          vertices = _shapeStringToVertices(
            shape,
            center: Vector2(double.parse(x), double.parse(y)),
            expand: 0.35,
          );
        }
      }

      if (vertices.length < 3) {
        continue;
      }

      InfrastructureComponent infrastructureComponent = InfrastructureComponent(
        id: id ?? "unknown",
        type: type,
        tags: tags,
        points: vertices,
      );

      infrastructureComponents.add(infrastructureComponent);
    }

    return infrastructureComponents;
  }

  static List<Map<String, String>> mapsFromXml(XmlDocument document, String identifier) {
    // identifier could be "additional/poly", "net/edge/lane", or "net/junction"
    final elements = document.xpath(identifier);

    List<Map<String, String>> elementMaps = [];

    for (var element in elements) {
      var elementMap = {};
      for (var attribute in element.attributes) {
        elementMap.addAll({attribute.name.toXmlString(): attribute.value});
      }

      elementMaps.add(elementMap.cast<String, String>());
    }

    return elementMaps;
  }

  // Convert a list of shape strings to a list of PolygonComponents
  static List<PolygonComponent> createPolygonsFromShapes(List<String> shapes) {
    List<PolygonComponent> polygons = [];

    for (final shape in shapes) {
      List<Vector2> vertices = _shapeStringToVertices(shape);

      if (vertices.length < 3) {
        continue;
      }

      polygons.add(PolygonComponent(vertices));
    }

    return polygons;
  }

  // Convert a list of shapes that represents a path to a list of PolygonComponents
  static List<PolygonComponent> createPolygonsFromPaths(List<String> shapes,
      {double width = 1.625}) {
    List<PolygonComponent> polygons = [];
    // List<List<Vector2>> polygons = [];
    // double width = 1.625 / parentSize.x;
    width /= parentSize.x;

    for (final shape in shapes) {
      var vertices = _pathStringToVertices(shape, width: width);
      if (vertices == []) {
        continue;
      }
      polygons.add(PolygonComponent(vertices));
    }

    return polygons;
  }

  static List<Vector2> _pathStringToVertices(String pathString,
      {required double width, double expand = 0}) {
    expand = 1 + expand;

    List<Vector2> path = _shapeStringToVertices(pathString);
    if (path.length < 2) {
      return [];
    }

    // make a simple rectangle if the path only has 2 points
    if (path.length == 2) {
      Vector2 p1 = path[0];
      Vector2 p2 = path[1];
      Vector2 v1 = p2 - p1;
      Vector2 widthDirection = Vector2(v1.y, -v1.x).normalized();
      List<Vector2> vertices = [
        p1 + widthDirection * width * expand,
        p2 + widthDirection * width * expand,
        p2 - widthDirection * width * expand,
        p1 - widthDirection * width * expand,
      ];
      return vertices;
    }

    List<Vector2> verticesLHS = [];
    List<Vector2> verticesRHS = [];
    // go through the path list with window of 3
    for (int i = 0; i < path.length - 2; i++) {
      Vector2 p1 = path[i];
      Vector2 p2 = path[i + 1];
      Vector2 p3 = path[i + 2];
      // find the vector between the vectors path[i]+path[i+1] and path[i+1]+path[i+2]
      Vector2 v1 = (p2 - p1).normalized();
      Vector2 v2 = (p3 - p2).normalized();
      Vector2 v12 = (v1 + v2).normalized();
      // find the perpendicular vector to v12
      Vector2 widthDirection = Vector2(v12.y, -v12.x);

      // if we're at the beginning we also want to add the perpendicular vector to the first point
      if (i == 0) {
        Vector2 perpv1 = Vector2(v1.y, -v1.x);
        verticesLHS.add(p1 + perpv1 * width * expand);
        verticesRHS.add(p1 - perpv1 * width * expand);
      }

      // add the perpendicular vectors to the path points to create vertices
      // while taking the angle to perpendicular vector into account
      // to account for a "kinking" factor of a bending path
      double kinkingFactor = (1 - v1.dot(v2)) * width / 2;
      double kinkedWidth = width + kinkingFactor;
      verticesLHS.add(p2 + widthDirection * kinkedWidth * expand);
      verticesRHS.add(p2 - widthDirection * kinkedWidth * expand);

      // if we're at the end we also want to add the perpendicular vector to the last point
      if (i == path.length - 3) {
        Vector2 perpv2 = Vector2(v2.y, -v2.x);
        verticesLHS.add(p3 + perpv2 * width * expand);
        verticesRHS.add(p3 - perpv2 * width * expand);
      }
    }

    return [...verticesLHS, ...verticesRHS.reversed];
  }

  static List<Vector2> _shapeStringToVertices(
    String shape, {
    Vector2? center,
    double expand = 0,
  }) {
    if (center == null && expand != 0) {
      throw Exception("Can't expand shape without center");
    }
    // expand = 1 + expand;
    return shape.split(' ').map((pair) {
      var coords = pair.split(',').map((coord) => double.parse(coord)).toList();
      Vector2 v = Vector2(coords[0], coords[1]);

      if (center != null) {
        // offset
        v.x -= center.x;
        v.y -= center.y;
        // expand
        v.x += v.normalized().x * expand;
        v.y += v.normalized().y * expand;

        // offset back
        v.x += center.x;
        v.y += center.y;
      }

      // Normalize the absolute coordinates to be relative to the parent size
      return Vector2(v.x / parentSize.x, v.y / parentSize.y);
    }).toList();
  }

  // lamp stuffs
  // reads the lamp data from the XML file
  static Future<List<Lamp>> lampsFromXml(String path) async {
    // Load the XML file
    l.d("Loading XML file from path: $path");
    XmlDocument document = await _loadXmlData(path);

    // Extract the lamp element maps from the XML document
    l.d("Extracting element maps from XML document");
    List<Map<String, String>> elementMaps = mapsFromXml(document, "lamps/lamp");
    l.d("Extracted ${elementMaps.length} element maps from XML document");

    // Create and return the list of Lamps
    l.d("Creating Lamps from element maps");
    return lampsFromMaps(elementMaps);
  }

  // creates Lamps from XML element Maps
  static List<Lamp> lampsFromMaps(List<Map<String, String>> elementMaps) {
    List<Lamp> lamps = [];

    for (var elementMap in elementMaps) {
      // get the id and type of the element
      String? id = elementMap["id"];
      String? x = elementMap["x"];
      String? y = elementMap["y"];

      if (x == null || y == null) {
        l.w("Element with id $id has no position");
        l.w("Element: $elementMap");
        continue;
      }

      Lamp lamp = Lamp(
        id: id ?? "unknown",
        lightLevel: 0.0,
        x: double.parse(x) / parentSize.x,
        y: double.parse(y) / parentSize.y,
      );

      lamps.add(lamp);
    }

    return lamps;
  }
}
