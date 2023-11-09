import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../logger.dart';

class NetworkUtils {
  static Vector2 parentSize = Vector2(0.1, 0.1);

  // Parses the JSON and returns a list of PolygonComponents for the shapes
  static Future<(List<PolygonComponent>, List<PolygonComponent>)> createPolygonsFromJson(
      String path) async {
    // Decode the JSON data
    var jsonData = await _loadJsonData(path);

    // Extract shapes from edges and junctions
    var (roads, junctions) = _extractShapes(jsonData);

    // Create and return the list of PolygonComponents
    return (createPolygonsFromPaths(roads), createPolygonsFromShapes(junctions));
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

      polygons.add(PolygonComponent(vertices));
    }

    return polygons;
  }

  // Convert a list of shapes that represents a path to a list of PolygonComponents
  static List<PolygonComponent> createPolygonsFromPaths(List<String> shapes) {
    List<PolygonComponent> polygons = [];
    double width = 1.6 / parentSize.x;

    for (final shape in shapes) {
      List<Vector2> path = shape.split(' ').map((pair) {
        var coords = pair.split(',').map((coord) => double.parse(coord)).toList();
        // Normalize the absolute coordinates to be relative to the parent size
        return Vector2(coords[0] / parentSize.x, coords[1] / parentSize.y);
      }).toList();

      if (path.length < 2) {
        continue;
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
        polygons.add(PolygonComponent(vertices));
        continue;
      }

      List<Vector2> verticesLHS = [];
      List<Vector2> verticesRHS = [];
      // go through the path list with window of 3
      for (int i = 0; i < path.length - 2; i++) {
        Vector2 p1 = path[i];
        Vector2 p2 = path[i + 1];
        Vector2 p3 = path[i + 2];
        // find the vector between the vectors path[i]+path[i+1] and path[i+1]+path[i+2]
        Vector2 v1 = p2 - p1;
        Vector2 v2 = p3 - p2;
        Vector2 v12 = (v1 + v2);
        // find the perpendicular vector to v12
        Vector2 widthDirection = Vector2(v12.y, -v12.x).normalized();

        // if we're at the beginning we also want to add the perpendicular vector to the first point
        if (i == 0) {
          Vector2 perpv1 = Vector2(v1.y, -v1.x).normalized();
          verticesLHS.add(p1 + perpv1 * width);
          verticesRHS.add(p1 - perpv1 * width);
        }

        // add the perpendicular vectors to the path points to create vertices
        verticesLHS.add(p2 + widthDirection * width);
        verticesRHS.add(p2 - widthDirection * width);

        // if we're at the end we also want to add the perpendicular vector to the last point
        if (i == path.length - 3) {
          Vector2 perpv2 = Vector2(v2.y, -v2.x).normalized();
          verticesLHS.add(p3 + perpv2 * width);
          verticesRHS.add(p3 - perpv2 * width);
        }
      }

      // collect the vertices in the correct order
      List<Vector2> vertices = [...verticesLHS, ...verticesRHS.reversed.toList()];
      polygons.add(PolygonComponent(vertices));
    }

    return polygons;
  }
}
