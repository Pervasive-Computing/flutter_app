import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;

class NetworkUtils {
  static Vector2 parentSize = Vector2(0.5, 0.5);

  // Parses the JSON and returns a list of PolygonComponents for the shapes
  static Future<(List<PolygonComponent>, List<PolygonComponent>)> createPolygonsFromJson(
      String path) async {
    // Decode the JSON data
    var jsonData = await _loadJsonData(path);

    // Extract shapes from edges and junctions
    var (roads, junctions) = _extractShapes(jsonData);

    // Create and return the list of PolygonComponents
    return (createPolygonsFromPathShapes(roads), createPolygonsFromShapes(junctions));
  }

  // Private helper method to extract shape strings from JSON data
  static (List<String>, List<String>) _extractShapes(dynamic jsonData) {
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

  // Convert a list of shape strings to a list of PolygonComponents
  static List<PolygonComponent> createPolygonsFromShapes(List<String> shapes) {
    List<PolygonComponent> polygons = [];

    for (final shape in shapes) {
      List<Vector2> vertices = shape.split(' ').map((pair) {
        var coords = pair.split(',').map((coord) => double.parse(coord)).toList();
        // Normalize the absolute coordinates to be relative to the parent size
        return Vector2(coords[0] / parentSize.x, coords[1] / parentSize.y);
      }).toList();

      if (vertices.length < 3) {
        continue;
      }

      // Create a PolygonComponent.relative with the vertices
      polygons.add(PolygonComponent.relative(
        vertices,
        parentSize: parentSize, // Use the static parent size
      ));
    }

    return polygons;
  }

  // Convert a list of shapes that represents a path to a list of PolygonComponents
  static List<PolygonComponent> createPolygonsFromPathShapes(List<String> shapes) {
    List<PolygonComponent> polygons = [];
    double width = 3.75;

    for (final shape in shapes) {
      List<Vector2> path = shape.split(' ').map((pair) {
        var coords = pair.split(',').map((coord) => double.parse(coord)).toList();
        // Normalize the absolute coordinates to be relative to the parent size
        return Vector2(coords[0] / parentSize.x, coords[1] / parentSize.y);
      }).toList();

      if (path.length < 2) {
        continue;
      }

      // between each pair of points in the path find the perpendicular vector
      // and add the perpendicular vectors to the path points to create vertices
      List<Vector2> vertices = [];
      for (int i = 0; i < path.length - 1; i++) {
        Vector2 p1 = path[i];
        Vector2 p2 = path[i + 1];
        Vector2 v = p2 - p1;
        Vector2 perp = Vector2(v.y, -v.x).normalized();
        vertices.add(p1 + perp * width);
        vertices.add(p2 + perp * width);
        vertices.add(p2 - perp * width);
        vertices.add(p1 - perp * width);
      }

      // Create a PolygonComponent.relative with the vertices
      polygons.add(PolygonComponent.relative(
        vertices,
        parentSize: parentSize, // Use the static parent size
      ));
    }

    return polygons;
  }
}
