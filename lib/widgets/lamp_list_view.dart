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
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'All Street Lamps',
              style: theme.textTheme.headlineLarge,
            ),
          ),
          Expanded(
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
              child: ListView.separated(
                padding: const EdgeInsets.only(
                    bottom: 30.0, top: 20.0), // Add bottom padding
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
        ],
      ),
    );
  }
}
