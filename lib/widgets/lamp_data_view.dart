import 'package:flutter/material.dart';
import '../components/lamp.dart';

class LampDataView extends StatefulWidget {
  final Lamp lamp;

  const LampDataView({
    super.key,
    this.lamp = const Lamp(id: 'NaN', lightLevel: 0),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Lamp ID: ${lamp.id}',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            const Icon(Icons.lightbulb_outline),
            const SizedBox(width: 10),
            Text(
              'Light Level: ${lamp.lightLevel}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
