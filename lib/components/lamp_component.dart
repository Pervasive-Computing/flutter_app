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
  Color? onColor;
  Color? offColor;
  late double bigRadius;
  // Paint paint = BasicPalette.yellow.paint();
  late CircleComponent main;
  late CircleComponent glow;
  late CircleComponent border;
  late final List<Function(LampComponent)> _onSelectCallbacks;
  late final List<Function(LampComponent)> _onDeselectCallbacks;

  LampComponent({
    required this.lamp,
    required Vector2 position,
    double radius = 100.0,
    this.borderWidth = 10,
    List<Function(LampComponent)> onSelectCallbacks = const [],
    List<Function(LampComponent)> onDeselectCallbacks = const [],
    this.onColor,
    this.offColor,
  })  : _onSelectCallbacks = onSelectCallbacks,
        _onDeselectCallbacks = onDeselectCallbacks,
        super(
          position: position,
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.grey.withOpacity(0),
        ) {
    onColor ??= const Color.fromARGB(255, 244, 188, 49);
    offColor ??= Colors.grey;

    main = CircleComponent(
      position: Vector2(radius, radius),
      anchor: anchor,
      radius: radius + 1,
      paint: Paint()..color = Color.lerp(offColor, onColor, lamp.lightLevel)!,
    );

    bigRadius = radius * 2;
    glow = CircleComponent(
      position: Vector2(radius, radius),
      anchor: anchor,
      radius: radius + bigRadius * lamp.lightLevel,
      paint: Paint()..color = onColor!.withOpacity(lamp.lightLevel / 2),
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

  void updateLevel(double level) {
    lamp.lightLevel = level;
    glow.radius = radius + bigRadius * lamp.lightLevel;
    glow.paint = Paint()..color = glow.paint.color.withOpacity(lamp.lightLevel / 2);
    main.paint = Paint()
      ..color =
          Color.lerp(Colors.grey, main.paint.color.withOpacity(lamp.lightLevel), lamp.lightLevel)!;
  }

  void setOnColor(Color color) {
    onColor = color;
    main.paint.color = Color.lerp(offColor, onColor, lamp.lightLevel)!;
  }

  void setOffColor(Color color) {
    offColor = color;
    main.paint.color = Color.lerp(offColor, onColor, lamp.lightLevel)!;
  }

  void fadeOpacityTo(double opacity, {double? duration}) async {
    // add(
    //   OpacityEffect.to(
    //     opacity,
    //     EffectController(
    //       duration: duration ?? 0.5,
    //     ),
    //   ),
    // );
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
