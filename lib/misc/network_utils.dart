import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';
import '../components/infrastructure_component.dart';
import '../logger.dart';

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

class NetworkUtils {
  static Vector2 parentSize = Vector2(0.1, 0.1);
  // enum of different types of infrastructure
  // {amenity, building, commercial, landuse, shop, parking, residential, school, university, tourism, leisure, sport}
  // static final

  // Parses the JSON and returns a list of PolygonComponents for the shapes
  static Future<(List<PolygonComponent>, List<PolygonComponent>)> createPolygonsFromJson(
      String path) async {
    // Decode the JSON data
    var jsonData = await _loadJsonData(path);

    // Extract shapes from edges and junctions
    var (roads, junctions) = _extractJsonShapes(jsonData);

    // Create and return the list of PolygonComponents
    return (
      createPolygonsFromPaths(roads),
      createPolygonsFromShapes(junctions),
    );
  }

  // Private helper method to extract shape strings from JSON data
  static (List<String>, List<String>) _extractJsonShapes(dynamic jsonData) {
    List<String> roads = [];
    List<String> junctions = [];

    // Extract shapes from edges
    for (var edge in jsonData['edges']) {
      List<String>? shapes = edge['shapes'].cast<String>();
      if (shapes == null || shapes.isEmpty) {
        continue;
      }
      roads.addAll(shapes);
    }

    // Extract shape from junctions
    for (var junction in jsonData['junctions']) {
      String? shape = junction['shape'];
      if (shape == null) {
        continue;
      }
      junctions.add(junction['shape']);
    }

    return (roads, junctions);
  }

  static Future<dynamic> _loadJsonData(String path) async {
    // Load the JSON file
    String jsonString = await rootBundle.loadString(path);
    // Decode the JSON data to a Dart object
    return jsonDecode(jsonString);
  }

  static Future<List<InfrastructureComponent>> infrastructureComponentsFromXml(String path) async {
    // Load the XML file
    l.d("Loading XML file from path: $path");
    XmlDocument document = await _loadXmlData(path);

    // Extract the infrastucture element maps from the XML document
    l.d("Extracting element maps from XML document");
    List<Map<String, String>> elementMaps = mapsFromXml(document, "additional/poly");
    l.d("Extracted ${elementMaps.length} element maps from XML document");

    // Extracting the road element maps from the XML document
    l.d("Extracting road element maps from XML document");
    List<Map<String, String>> roadElementMaps = mapsFromXml(document, "net/edge/lane");
    l.d("Extracted ${roadElementMaps.length} road element maps from XML document");

    // Extracting the junction element maps from the XML document
    l.d("Extracting junction element maps from XML document");
    List<Map<String, String>> junctionElementMaps = mapsFromXml(document, "net/junction");
    l.d("Extracted ${junctionElementMaps.length} junction element maps from XML document");

    // Create and return the list of InfrastructureComponents
    l.d("Creating InfrastructureComponents from element maps");
    return infrastructureComponentsFromMaps(elementMaps);
  }

  static Future<XmlDocument> _loadXmlData(String path) async {
    // Load the XML file
    String xmlString = await rootBundle.loadString(path);
    // Decode the XML data to a Dart object
    return XmlDocument.parse(xmlString);
  }

  // creates InfrastructureComponents from XML element Maps
  static List<InfrastructureComponent> infrastructureComponentsFromMaps(
      List<Map<String, String>> elementMaps) {
    List<InfrastructureComponent> infrastructureComponents = [];

    for (var elementMap in elementMaps) {
      // get the id and type of the element
      String? id = elementMap["id"];
      String? type = elementMap["type"];
      String? roadAllow = elementMap["allow"];

      List<String>? tags;

      if (roadAllow != null) {
        // get the tags of the element
        tags = roadAllow.split(" ");
      } else {
        tags = [];
      }

      // get the shape of the element
      String shape = elementMap["shape"]!;

      List<Vector2> vertices;
      if (type == null) {
        vertices = _pathStringToVertices(shape, width: 1);
      } else {
        vertices = _shapeStringToVertices(shape);
      }

      if (vertices.length < 3) {
        continue;
      }

      InfrastructureComponent infrastructureComponent = InfrastructureComponent(
        id: id ?? "unknown",
        type: type ?? "noncar",
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
      // List<Vector2> path = _shapeStringToVertices(shape);

      // if (path.length < 2) {
      //   continue;
      // }

      // // make a simple rectangle if the path only has 2 points
      // if (path.length == 2) {
      //   Vector2 p1 = path[0];
      //   Vector2 p2 = path[1];
      //   Vector2 v1 = p2 - p1;
      //   Vector2 widthDirection = Vector2(v1.y, -v1.x).normalized();
      //   List<Vector2> vertices = [
      //     p1 + widthDirection * width,
      //     p2 + widthDirection * width,
      //     p2 - widthDirection * width,
      //     p1 - widthDirection * width,
      //   ];
      //   polygons.add(PolygonComponent(vertices));
      //   continue;
      // }

      // List<Vector2> verticesLHS = [];
      // List<Vector2> verticesRHS = [];
      // // go through the path list with window of 3
      // for (int i = 0; i < path.length - 2; i++) {
      //   Vector2 p1 = path[i];
      //   Vector2 p2 = path[i + 1];
      //   Vector2 p3 = path[i + 2];
      //   // find the vector between the vectors path[i]+path[i+1] and path[i+1]+path[i+2]
      //   Vector2 v1 = (p2 - p1).normalized();
      //   Vector2 v2 = (p3 - p2).normalized();
      //   Vector2 v12 = (v1 + v2).normalized();
      //   // find the perpendicular vector to v12
      //   Vector2 widthDirection = Vector2(v12.y, -v12.x);

      //   // if we're at the beginning we also want to add the perpendicular vector to the first point
      //   if (i == 0) {
      //     Vector2 perpv1 = Vector2(v1.y, -v1.x);
      //     verticesLHS.add(p1 + perpv1 * width);
      //     verticesRHS.add(p1 - perpv1 * width);
      //   }

      //   // add the perpendicular vectors to the path points to create vertices
      //   // while taking the angle to perpendicular vector into account
      //   // to account for a "kinking" factor of a bending path
      //   double kinkingFactor = (1 - v1.dot(v2)) * width / 2;
      //   double kinkedWidth = width + kinkingFactor;
      //   verticesLHS.add(p2 + widthDirection * kinkedWidth);
      //   verticesRHS.add(p2 - widthDirection * kinkedWidth);

      //   // if we're at the end we also want to add the perpendicular vector to the last point
      //   if (i == path.length - 3) {
      //     Vector2 perpv2 = Vector2(v2.y, -v2.x);
      //     verticesLHS.add(p3 + perpv2 * width);
      //     verticesRHS.add(p3 - perpv2 * width);
      //   }
      // }

      // // collect the vertices in the correct order
      // List<Vector2> vertices = [...verticesLHS, ...verticesRHS.reversed];
      // polygons.add(PolygonComponent(vertices));
      var vertices = _pathStringToVertices(shape, width: width);
      if (vertices == []) {
        continue;
      }
      polygons.add(PolygonComponent(vertices));
    }

    return polygons;
  }

  static List<Vector2> _pathStringToVertices(String pathString, {required double width}) {
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
        p1 + widthDirection * width,
        p2 + widthDirection * width,
        p2 - widthDirection * width,
        p1 - widthDirection * width,
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
        verticesLHS.add(p1 + perpv1 * width);
        verticesRHS.add(p1 - perpv1 * width);
      }

      // add the perpendicular vectors to the path points to create vertices
      // while taking the angle to perpendicular vector into account
      // to account for a "kinking" factor of a bending path
      double kinkingFactor = (1 - v1.dot(v2)) * width / 2;
      double kinkedWidth = width + kinkingFactor;
      verticesLHS.add(p2 + widthDirection * kinkedWidth);
      verticesRHS.add(p2 - widthDirection * kinkedWidth);

      // if we're at the end we also want to add the perpendicular vector to the last point
      if (i == path.length - 3) {
        Vector2 perpv2 = Vector2(v2.y, -v2.x);
        verticesLHS.add(p3 + perpv2 * width);
        verticesRHS.add(p3 - perpv2 * width);
      }
    }

    return [...verticesLHS, ...verticesRHS.reversed];
  }

  static List<Vector2> _shapeStringToVertices(String shape) {
    return shape.split(' ').map((pair) {
      var coords = pair.split(',').map((coord) => double.parse(coord)).toList();
      // Normalize the absolute coordinates to be relative to the parent size
      return Vector2(coords[0] / parentSize.x, coords[1] / parentSize.y);
    }).toList();
  }
}
