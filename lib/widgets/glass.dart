import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const Glass({
    super.key,
    required this.child,
    this.height = double.infinity,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: height,
      width: width,
      blur: 15,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      borderWidth: 2,
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.20),
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.3)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.39, 0.40, 1.0],
      ),
      child: child,
    );
  }
}
