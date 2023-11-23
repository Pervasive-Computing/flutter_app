import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class Glass extends StatefulWidget {
  final Widget child;
  final double height;
  final double width;
  final EdgeInsets padding;
  final double opacity;
  final double blur;
  final Color? color;

  const Glass({
    super.key,
    required this.child,
    this.height = double.infinity,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(0),
    this.opacity = 0.2,
    this.blur = 25,
    this.color,
  });

  @override
  State<Glass> createState() => GlassState();
}

class GlassState extends State<Glass> {
  Color? color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).colorScheme.onPrimary;
    return GlassContainer(
      padding: widget.padding,
      height: widget.height,
      width: widget.width,
      blur: widget.blur,
      borderRadius: const BorderRadius.all(Radius.circular(35)),
      borderWidth: 2,
      gradient: LinearGradient(
        colors: [
          color!.withOpacity((widget.opacity).clamp(0, 1)),
          color!.withOpacity((widget.opacity * 0.75).clamp(0, 1)),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          color!.withOpacity((widget.opacity * 0.75).clamp(0, 1)),
          color!.withOpacity((widget.opacity * 0.5).clamp(0, 1)),
          color!.withOpacity((widget.opacity * 0.2).clamp(0, 1)),
          color!.withOpacity((widget.opacity * 1.2).clamp(0, 1))
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.39, 0.40, 1.0],
      ),
      child: widget.child,
    );
  }
}
