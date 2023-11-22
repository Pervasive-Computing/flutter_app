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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        child: Container(
          //padding: EdgeInsets.all(16),
          child: Text(lamp.id),
        ),
      ),
    );
  }
}
