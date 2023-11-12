import 'package:flame/game.dart';
// import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'widgets/sim_visualiser.dart';
import 'widgets/glass.dart';
// import 'widgets/sim_world.dart';
// import 'package:flutter/gestures.dart';
// import '../logger.dart';
// import '../websocket/simulation_api.dart';

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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Glass(
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
            ),
          ),
        ],
      ),
    );
  }
}
