import 'package:flame/components.dart';
import 'package:flame/palette.dart';

// ╒══════════════════════════════════════════════════════════════════════════════╕
// │                        ⏹️ Infrastructure Component                         │
// ╘══════════════════════════════════════════════════════════════════════════════╛
// InfrastructureComponent
// wraps the flame game polygon component, and adds some meta data
class InfrastructureComponent extends PolygonComponent {
  // meta data
  String id;
  String type;
  List<String> tags = [];

  InfrastructureComponent({
    required this.id,
    required this.type,
    required this.tags,
    required List<Vector2> points,
  }) : super(points);
}
