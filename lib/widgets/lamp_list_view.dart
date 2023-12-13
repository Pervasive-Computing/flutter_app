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
      padding: const EdgeInsets.only(left: 30, right: 15.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 3),
            child: Text(
              'All Street Lamps',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(theme
                    .colorScheme.onBackground
                    .withOpacity(0.2)), // Thumb color
                thickness: MaterialStateProperty.all(
                    6.0), // Thickness of the scrollbar
                radius:
                    const Radius.circular(8), // Radius of the scrollbar thumb
                // Add any other necessary ScrollbarThemeData properties here
              ),
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.surface,
                      theme.colorScheme.surface,
                      Colors.transparent
                    ],
                    stops: const [
                      0.0,
                      0.05,
                      0.95,
                      1.0
                    ], // Adjust the middle stops closer to the ends
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Scrollbar(
                  child: ListView.separated(
                    primary: true,
                    padding: const EdgeInsets.only(
                        bottom: 30.0,
                        top: 20.0,
                        right: 15.0), // Adjusted padding for top and bottom
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
                          height: 8.0); // Maintain separation between items
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
