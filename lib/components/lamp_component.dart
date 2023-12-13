import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'lamp.dart';
import '../logger.dart';

// ╒══════════════════════════════════════════════════════════════════════════════╕
// │                          💡 Street Lamp Component                           │
// ╘══════════════════════════════════════════════════════════════════════════════╛
// flame game lamp component extending circle component
class LampComponent extends CircleComponent with TapCallbacks {
  Lamp lamp;
  double borderWidth;
  bool _isSelected = false;
  // Paint paint = BasicPalette.yellow.paint();
  late CircleComponent main;
  late CircleComponent glow;
  late CircleComponent border;
  late List<Function(LampComponent)> _onSelectCallbacks;
  late List<Function(LampComponent)> _onDeselectCallbacks;

  LampComponent({
    required this.lamp,
    required Vector2 position,
    double radius = 100.0,
    this.borderWidth = 10,
    List<Function(LampComponent)> onSelectCallbacks = const [],
    List<Function(LampComponent)> onDeselectCallbacks = const [],
    Color color = const Color.fromARGB(255, 244, 188, 49),
  })  : _onSelectCallbacks = onSelectCallbacks,
        _onDeselectCallbacks = onDeselectCallbacks,
        super(
          position: position,
          radius: radius,
          anchor: Anchor.center,
        ) {
    main = CircleComponent(
      position: Vector2.zero(),
      radius: radius,
      paint: Paint()..color = color,
    );

    final bigRadius = radius * 3 * lamp.lightLevel;
    glow = CircleComponent(
      position: Vector2(radius, radius),
      anchor: anchor,
      radius: bigRadius,
      paint: Paint()..color = color.withOpacity(lamp.lightLevel / 2),
    );
  }

  void addSelectCallback(Function(LampComponent) callback) {
    _onSelectCallbacks.add(callback);
  }

  void addDeselectCallback(Function(LampComponent) callback) {
    _onDeselectCallbacks.add(callback);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    addAll([
      main,
      glow,
    ]);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    // l.d("Tapped on lamp ${lamp.id}\nWith event: $event");
    _isSelected = !_isSelected;

    if (_isSelected) {
      l.w("Lamp ${lamp.id} selected");
      for (var callback in _onSelectCallbacks) {
        callback(this);
      }
    } else {
      l.w("Lamp ${lamp.id} deselected");
      for (var callback in _onDeselectCallbacks) {
        callback(this);
      }
    }

    return true;
  }

  void select() {
    _isSelected = true;
  }

  void deselect() {
    _isSelected = false;
  }

  void shouldRender(bool shouldRender) {
    main.renderShape = shouldRender;
    glow.renderShape = shouldRender;
  }

  void fadeOpacityTo(double opacity, {double? duration}) async {
    add(
      OpacityEffect.to(
        opacity,
        EffectController(
          duration: duration ?? 0.5,
        ),
      ),
    );
    add(
      OpacityEffect.to(
        opacity,
        EffectController(
          duration: duration ?? 0.5,
        ),
        target: main,
      ),
    );
    final double glowOpacity = opacity > 0 ? lamp.lightLevel / 2 : 0;
    add(
      OpacityEffect.to(
        glowOpacity,
        EffectController(
          duration: duration ?? 0.5,
        ),
        target: glow,
      ),
    );
  }
}
