import 'package:flame/game.dart';
// import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'widgets/sim_visualiser.dart';
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
              Expanded(
                child: GameWidget(
                  game: SimVisualiser(
                    context: context,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
