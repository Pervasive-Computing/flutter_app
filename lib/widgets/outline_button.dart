import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Function()? onPressed;
  final bool hasBorder;

  const CircleIconButton({
    Key? key,
    this.color = Colors.blue,
    this.icon = Icons.add,
    this.onPressed,
    this.hasBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return your widget here
    return MaterialButton(
      hoverColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.25),
      padding: const EdgeInsets.all(0),
      minWidth: 0,
      onPressed: () {
        // call all callbacks here
        onPressed?.call();
      },
      shape: hasBorder
          ? CircleBorder(
              side: BorderSide(
              color: color,
              width: 2,
            ))
          : const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
