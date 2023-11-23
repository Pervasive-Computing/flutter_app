import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import '../themes/catppuccin_theme.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final EdgeInsets padding;
  final double opacity;
  final double blur;
  Color? color;

  Glass({
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
  Widget build(BuildContext context) {
    final theme = context.catppuccinTheme;
    color ??= theme.materialTheme.colorScheme.onPrimary;
    return GlassContainer(
      padding: padding,
      height: height,
      width: width,
      blur: blur,
      borderRadius: const BorderRadius.all(Radius.circular(35)),
      borderWidth: 2,
      gradient: LinearGradient(
        colors: [
          color!.withOpacity((opacity).clamp(0, 1)),
          color!.withOpacity((opacity * 0.75).clamp(0, 1)),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          color!.withOpacity((opacity * 0.75).clamp(0, 1)),
          color!.withOpacity((opacity * 0.5).clamp(0, 1)),
          color!.withOpacity((opacity * 0.2).clamp(0, 1)),
          color!.withOpacity((opacity * 1.2).clamp(0, 1))
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.39, 0.40, 1.0],
      ),
      child: child,
    );
  }
}
