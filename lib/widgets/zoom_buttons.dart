import 'package:flutter/material.dart';
import 'circle_icon_button.dart';
import 'glass.dart';

class ZoomButtons extends StatelessWidget {
  final Function() onZoomInPressed;
  final Function() onZoomOutPressed;

  const ZoomButtons({
    super.key,
    required this.onZoomInPressed,
    required this.onZoomOutPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      right: 0,
      bottom: 0,
      child: Glass(
        // padding: const EdgeInsets.symmetric(horizontal: 17),
        height: 70,
        width: 123,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleIconButton(
                icon: Icons.remove,
                color: theme.colorScheme.onBackground,
                onPressed: onZoomOutPressed,
              ),
              const SizedBox(width: 10),
              CircleIconButton(
                icon: Icons.add,
                color: theme.colorScheme.onBackground,
                onPressed: onZoomInPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
