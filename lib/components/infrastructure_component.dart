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

  InfrastructureComponent({
    required this.id,
    required this.type,
    required List<Vector2> points,
  }) : super(points);
}
