import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass.dart';
import 'circle_icon_button.dart';

class Header extends StatelessWidget {
  final ValueNotifier<String> _themeNotifier;
  final double height;
  final Function()? onMenuPressed;

  const Header({
    super.key,
    this.height = 70,
    required ValueNotifier<String> themeNotifier,
    this.onMenuPressed,
  }) : _themeNotifier = themeNotifier;

  void toggleTheme() {
    if (_themeNotifier.value == 'latte') {
      _themeNotifier.value = 'mocha';
    } else {
      _themeNotifier.value = 'latte';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Glass(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      height: height,
      child: Row(
        children: [
          CircleIconButton(
            onPressed: () {
              onMenuPressed?.call();
            },
            icon: Icons.menu,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          Expanded(
            child: Center(
              child: Text(
                "UrbanOS",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ),
          ),
          // CircleIconButton(
          //   onPressed: () {
          //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          //         overlays: [SystemUiOverlay.bottom]);
          //   },
          //   icon: Icons.search,
          //   color: Theme.of(context).colorScheme.onBackground,
          // ),
          CircleIconButton(
            onPressed: () {
              toggleTheme();
            },
            icon: _themeNotifier.value == 'latte'
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
    );
  }
}
