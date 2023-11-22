import 'package:flutter/material.dart';
import 'lamp_item.dart';
import '../components/lamp.dart';

class LampListView extends StatelessWidget {
  final List<Lamp> lamps;

  const LampListView({
    super.key,
    required this.lamps,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lamps.length,
      itemBuilder: (context, index) {
        return LampItem(
          lamp: lamps[index],
          onClick: () {
            //print('Clicked on ${lamps[index]}');
          },
        );
      },
    );
  }
}
