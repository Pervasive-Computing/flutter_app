import 'package:flutter/material.dart';
import '../themes/catppuccin_theme.dart';
import '../components/lamp.dart';
import '../logger.dart';

class LampDataView extends StatefulWidget {
  final Lamp lamp;
  final Function onPressed;

  const LampDataView({
    super.key,
    this.lamp = const Lamp(id: 'NaN', lightLevel: 0),
    required this.onPressed,
  });

  @override
  State<LampDataView> createState() => LampDataViewState();
}

class LampDataViewState extends State<LampDataView> {
  late Lamp lamp;

  @override
  void initState() {
    super.initState();
    lamp = widget.lamp;
  }

  void updateContent(Lamp lamp) {
    l.d("before setstate");
    setState(() {
      this.lamp = lamp;
      l.d("updateContent, lamp id: ${this.lamp.id}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.catppuccinTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.onPressed();
              },
            ),
            Text(
              'Lamp ID: ${lamp.id}',
              style: theme.materialTheme.textTheme.headlineLarge,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            const Icon(Icons.lightbulb_outline),
            const SizedBox(width: 10),
            Text(
              'Light Level: ${lamp.lightLevel}',
              style: theme.materialTheme.textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
