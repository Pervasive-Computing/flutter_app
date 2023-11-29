import 'package:flutter/material.dart';
import 'lamp_item.dart';
import '../components/lamp.dart';
// import '../logger.dart';

class LampListView extends StatelessWidget {
  final List<Lamp> lamps;
  final Function onPressed;

  const LampListView({
    super.key,
    required this.lamps,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'All Street Lamps',
              style: theme.textTheme.headlineLarge,
            ),
          ),
          Expanded(
            // Wrapping ListView.builder in an Expanded widget
            child: ListView.separated(
              itemCount: lamps.length,
              itemBuilder: (context, index) {
                return LampItem(
                  lamp: lamps[index],
                  onClick: () {
                    onPressed(index);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                    height: 8.0); //Add a divider between each item
              },
            ),
          ),
        ],
      ),
    );
  }
}
