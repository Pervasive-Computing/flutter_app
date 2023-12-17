import 'package:flutter/material.dart';
// import '../themes/catppuccin_theme.dart';
import 'glass.dart';
import 'circle_icon_button.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import '../logger.dart';

class Header extends StatefulWidget {
  final ValueNotifier<Flavor> themeNotifier;
  final ValueNotifier<bool> sidebarNotifier;
  final double height;
  final Function()? onMenuPressed;
  final Function()? onToggleBuildingsPressed;
  final Function()? onToggleCarsPressed;
  final Function()? onToggleLampsPressed;

  const Header({
    super.key,
    this.height = 70,
    required this.themeNotifier,
    required this.sidebarNotifier,
    this.onMenuPressed,
    this.onToggleBuildingsPressed,
    this.onToggleCarsPressed,
    this.onToggleLampsPressed,
  });

  @override
  State<Header> createState() => HeaderState();
}

class HeaderState extends State<Header> {
  double turns = 0;
  bool _buildingsToggled = false;
  bool _carsToggled = true;
  bool _lampsToggled = true;
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

    // windowHeight = MediaQuery.of(context).size.height;
    final windowWidth = MediaQuery.of(context).size.width;

    // l.w("windowWidth: $windowWidth");

    final logo = Text(
      windowWidth > 500 ? "UrbanOS" : "UOS",
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );

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
              child: logo,
            ),
          ),
          CircleIconButton(
            onPressed: () {
              widget.onToggleCarsPressed?.call();
              setState(() {
                _carsToggled = !_carsToggled;
              });
            },
            icon: _carsToggled ? Icons.car_crash : Icons.car_crash_outlined,
            color: theme.colorScheme.onBackground,
          ),
          const SizedBox(width: 10),
          CircleIconButton(
            onPressed: () {
              widget.onToggleLampsPressed?.call();
              setState(() {
                _lampsToggled = !_lampsToggled;
              });
            },
            icon: _lampsToggled ? Icons.lightbulb : Icons.lightbulb_outline,
            color: theme.colorScheme.onBackground,
          ),
          const SizedBox(width: 10),
          CircleIconButton(
            onPressed: () {
              widget.onToggleBuildingsPressed?.call();
              setState(() {
                _buildingsToggled = !_buildingsToggled;
              });
            },
            icon: _buildingsToggled ? Icons.home_work : Icons.home_work_outlined,
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
