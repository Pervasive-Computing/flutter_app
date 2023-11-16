import 'dart:math';

import 'package:flame/game.dart';
// import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'widgets/sim_visualiser.dart';
import 'widgets/header.dart';
// import 'widgets/sim_world.dart';
// import 'package:flutter/gestures.dart';
import '../logger.dart';
// import '../websocket/simulation_api.dart';
import 'widgets/sidebar.dart';

class Home extends StatefulWidget {
  final ValueNotifier<String> themeNotifier;

  const Home({
    super.key,
    required this.themeNotifier,
  });

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  // final ValueNotifier<String> _themeNotifier;
  late final SimVisualiser _simulation;
  final GlobalKey<SidebarState> sidebarKey = GlobalKey<SidebarState>();
  final double headerHeight = 70;
  final double padding = 20;

  double windowWidth = 0;
  double windowHeight = 0;
  double sidebarHeight = 0;
  double sidebarWidth = 0;

  // Home({
  //   super.key,
  //   // required ValueNotifier<String> themeNotifier,
  // }) : _themeNotifier = themeNotifier {
  //   _simulation = SimVisualiser();
  // }

  @override
  void initState() {
    super.initState();
    _simulation = SimVisualiser();

    // setstate with window width and height
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        windowHeight = MediaQuery.of(context).size.height;
        windowWidth = MediaQuery.of(context).size.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _simulation.context = context;
    _simulation.setColors();

    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    sidebarHeight = windowHeight - padding * 3 - headerHeight;
    sidebarWidth = min(windowWidth - padding * 2, 500);
    sidebarKey.currentState?.height = sidebarHeight;
    sidebarKey.currentState?.width = sidebarWidth;

    return Container(
      constraints: BoxConstraints(
        maxHeight: windowHeight,
        maxWidth: windowWidth,
      ),
      color: Theme.of(context).colorScheme.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(
            game: _simulation,
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Header(
                  themeNotifier: widget.themeNotifier,
                  onMenuPressed: () {
                    sidebarKey.currentState?.toggleSidebar();
                  },
                ),
                Sidebar(
                  key: sidebarKey,
                  height: sidebarHeight,
                  width: 500,
                  top: headerHeight + padding,
                  extraMovement: padding,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
