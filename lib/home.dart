import 'package:flame/game.dart';
// import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'widgets/sim_visualiser.dart';
import 'widgets/header.dart';
// import 'widgets/sim_world.dart';
// import 'package:flutter/gestures.dart';
// import '../logger.dart';
// import '../websocket/simulation_api.dart';
import 'widgets/sidebar.dart';

class Home extends StatelessWidget {
  Home({
    super.key,
    required ValueNotifier<String> themeNotifier,
  }) : _themeNotifier = themeNotifier {
    // SimulationAPI.connect();
    _simulation = SimVisualiser();
  }

  final ValueNotifier<String> _themeNotifier;
  late final SimVisualiser _simulation;

  // SimulationAPI instance
  // final SimulationAPI _simulationAPI = SimulationAPI();

  final GlobalKey<SidebarState> sidebarKey = GlobalKey<SidebarState>();

  @override
  Widget build(BuildContext context) {
    _simulation.context = context;
    var windowWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: windowWidth,
      ),
      color: Theme.of(context).colorScheme.background,
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: windowWidth,
            ),
            child: GameWidget(
              game: _simulation,
            ),
          ),
          // TEMP BUTTON, TO TEST SIDEBAR
          Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Header(
                  themeNotifier: _themeNotifier,
                ),
                Sidebar(key: sidebarKey),
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                sidebarKey.currentState?.openSidebar();
              },
              child: const Text('Open Sidebar'),
            ),
          ),
        ],
      ),
    );
  }
}
