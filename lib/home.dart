import 'package:flame/game.dart';
// import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'widgets/sim_visualiser.dart';
import 'widgets/sim_world.dart';
import 'package:flutter/gestures.dart';
// import '../logger.dart';
// import '../websocket/simulation_api.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // SimulationAPI instance
  // final SimulationAPI _simulationAPI = SimulationAPI();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final simulation = SimVisualiser(context: context);
        // final size = constraints.biggest;
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Simulation",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              // Expanded(
              //   child: RawGestureDetector(
              //     gestures: <Type, GestureRecognizerFactory>{
              //       // Factory for pan (two-finger scroll) gestures
              //       PanGestureRecognizer:
              //           GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
              //         () => PanGestureRecognizer(),
              //         (PanGestureRecognizer instance) {
              //           instance.onUpdate = (details) {
              //             // Handle two-finger scroll on touchpad
              //             simulation.scrollZoom(details.delta.dy);
              //             // Make sure to clamp your zoom level
              //           };
              //         },
              //       ),
              //     },
              //     behavior: HitTestBehavior.opaque,
              //     child: GameWidget(
              //       game: simulation,
              //     ),
              //   ),
              // ),
              Expanded(
                child: GameWidget(
                  game: simulation,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
