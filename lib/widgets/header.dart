import 'package:flutter/material.dart';
// import '../themes/catppuccin_theme.dart';
import 'glass.dart';
import 'circle_icon_button.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
// import '../logger.dart';

class Header extends StatefulWidget {
  final ValueNotifier<Flavor> themeNotifier;
  final ValueNotifier<bool> sidebarNotifier;
  final double height;
  final Function()? onMenuPressed;
  final Function()? onTogglePressed;

  const Header({
    super.key,
    this.height = 70,
    required this.themeNotifier,
    required this.sidebarNotifier,
    this.onMenuPressed,
    this.onTogglePressed,
  });

  @override
  State<Header> createState() => HeaderState();
}

class HeaderState extends State<Header> {
  double turns = 0;
  bool toggled = false;
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
    if (widget.themeNotifier.value == catppuccin.latte) {
      widget.themeNotifier.value = catppuccin.mocha;
    } else {
      widget.themeNotifier.value = catppuccin.latte;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              color: theme.colorScheme.onBackground,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "UrbanOS",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          CircleIconButton(
            onPressed: () {
              widget.onTogglePressed?.call();
              setState(() {
                toggled = !toggled;
              });
            },
            icon: toggled ? Icons.home_work_outlined : Icons.home_work,
            color: theme.colorScheme.onBackground,
          ),
          const SizedBox(width: 10),
          CircleIconButton(
            onPressed: () {
              toggleTheme();
            },
            icon: theme.colorScheme.brightness == Brightness.light
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            color: theme.colorScheme.onBackground,
          ),
        ],
      ),
    );
  }
}
