import 'dart:convert';
import 'package:flame/components.dart';

// Assuming a parent size of 800x600 for normalization
Vector2 parentSize = Vector2(800, 600);

List<PolygonComponent> createPolygonsFromShapes(List<String> shapes, Vector2 parentSize) {
  return shapes.map((shape) {
    // Split the shape string into coordinate pairs and parse them into Vector2
    List<Vector2> vertices = shape.split(' ').map((pair) {
      var coords = pair.split(',').map((coord) => double.parse(coord)).toList();
      // Normalize the absolute coordinates to be relative to the parent size
      return Vector2(coords[0] / parentSize.x, coords[1] / parentSize.y);
    }).toList();

    // Create a PolygonComponent.relative with the vertices
    return PolygonComponent.relative(
      vertices,
      parentSize: parentSize, // Set the size to your parent component's size
    );
  }).toList();
}
