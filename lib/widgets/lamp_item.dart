import 'package:flutter/material.dart';
import '../components/lamp.dart';

class LampItem extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets padding;

  final Lamp lamp;
  final VoidCallback onClick;

  const LampItem({
    super.key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.padding = const EdgeInsets.all(0),
    required this.lamp,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(15.0), // Add this line
        child: Ink(
          // Use Ink instead of Container for the ripple effect
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.onPrimary), // Outline color
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text("Lamp ${lamp.id}"),
          ),
        ),
      ),
    );
  }
}
