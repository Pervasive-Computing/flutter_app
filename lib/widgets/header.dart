import 'package:flutter/material.dart';
import 'glass.dart';
import 'outline_button.dart';

class Header extends StatelessWidget {
  final ValueNotifier<String> _themeNotifier;

  const Header({
    super.key,
    required ValueNotifier<String> themeNotifier,
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
      height: 70,
      child: Row(
        children: [
          CircleIconButton(
            onPressed: () {},
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
