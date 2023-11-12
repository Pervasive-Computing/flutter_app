import 'package:flutter/material.dart';
import 'glass.dart';

class Header extends StatelessWidget {
  final ValueNotifier<String> _themeNotifier;

  const Header({
    super.key,
    required ValueNotifier<String> themeNotifier,
  }) : _themeNotifier = themeNotifier;

  @override
  Widget build(BuildContext context) {
    return Glass(
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "UrbanOS",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                      ),
                ),
              ),
            ),
          ),
          MaterialButton(
            hoverColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.25),
            padding: const EdgeInsets.all(0),
            minWidth: 0,
            onPressed: () {
              if (_themeNotifier.value == 'latte') {
                _themeNotifier.value = 'mocha';
              } else {
                _themeNotifier.value = 'latte';
              }
            },
            shape: CircleBorder(
                side: BorderSide(
              color: Theme.of(context).colorScheme.onBackground,
              width: 2,
            )),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                _themeNotifier.value == 'latte'
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
