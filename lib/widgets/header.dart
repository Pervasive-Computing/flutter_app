import 'package:flutter/material.dart';
import 'glass.dart';
import 'circle_icon_button.dart';
import 'sidebar.dart';
import '../logger.dart';

class Header extends StatefulWidget {
  final ValueNotifier<String> _themeNotifier;
  final double height;
  final Function()? onMenuPressed;
  final GlobalKey<SidebarState>? sidebarKey;

  const Header({
    super.key,
    this.height = 70,
    required ValueNotifier<String> themeNotifier,
    this.onMenuPressed,
    this.sidebarKey,
  }) : _themeNotifier = themeNotifier;

  @override
  State<Header> createState() => HeaderState();
}

class HeaderState extends State<Header> {
  late GlobalKey<SidebarState>? _sidebarKey;

  @override
  void initState() {
    super.initState();
    _sidebarKey = widget.sidebarKey;
  }

  @override
  void didUpdateWidget(covariant Header oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sidebarKey = widget.sidebarKey;
  }

  void toggleTheme() {
    if (widget._themeNotifier.value == 'latte') {
      widget._themeNotifier.value = 'mocha';
    } else {
      widget._themeNotifier.value = 'latte';
    }
  }

  @override
  Widget build(BuildContext context) {
    // print information about the sidebarkeey
    l.w("sidebarKey.getState(): ${_sidebarKey?.currentState?.getState()}");
    return Glass(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      height: widget.height,
      child: Row(
        children: [
          CircleIconButton(
            onPressed: () {
              widget.onMenuPressed?.call();
            },
            icon: _sidebarKey == null || _sidebarKey!.currentState == null
                ? Icons.menu
                : _sidebarKey!.currentState!.getState()
                    ? Icons.chevron_right
                    : Icons.chevron_left,
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
            icon: widget._themeNotifier.value == 'latte'
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
    );
  }
}
