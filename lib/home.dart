import 'package:flame/game.dart';
// import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'widgets/sim_visualiser.dart';
import 'package:glass_kit/glass_kit.dart';
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
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: 100,
              width: windowWidth,
              blur: 15,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              borderWidth: 2,
              // borderColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
              // color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderGradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.20),
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
                  Theme.of(context).colorScheme.onPrimary.withOpacity(0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.39, 0.40, 1.0],
              ),
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
