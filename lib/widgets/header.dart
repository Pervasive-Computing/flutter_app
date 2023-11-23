import 'package:flutter/material.dart';
import 'glass.dart';
import 'circle_icon_button.dart';
// import '../logger.dart';

class Header extends StatefulWidget {
  final ValueNotifier<String> themeNotifier;
  final ValueNotifier<bool> sidebarNotifier;
  final double height;
  final Function()? onMenuPressed;

  const Header({
    super.key,
    this.height = 70,
    required this.themeNotifier,
    required this.sidebarNotifier,
    this.onMenuPressed,
  });

  @override
  State<Header> createState() => HeaderState();
}

class HeaderState extends State<Header> {
  double turns = 0;
  // trigger rebuild when sidebar state changes
  @override
  void initState() {
    super.initState();
    widget.sidebarNotifier.addListener(() {
      setState(() {
        // turn 180 degrees when sidebar is open
        if (widget.sidebarNotifier.value) {
          turns = 0.5;
        } else {
          turns = 0;
        }
      });
    });
  }

  // trigger rebuild when theme changes
  void toggleTheme() {
    if (widget.themeNotifier.value == 'latte') {
      widget.themeNotifier.value = 'mocha';
    } else {
      widget.themeNotifier.value = 'latte';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Glass(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      height: widget.height,
      child: Row(
        children: [
          AnimatedRotation(
            turns: turns,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: CircleIconButton(
              onPressed: () {
                widget.onMenuPressed?.call();
              },
              icon: Icons.chevron_right,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "UrbanOS",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          CircleIconButton(
            onPressed: () {
              toggleTheme();
            },
            icon: widget.themeNotifier.value == 'latte'
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
    );
  }
}
