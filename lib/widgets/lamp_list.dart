import 'package:flutter/material.dart';
import 'lamp_item.dart';
import '../components/lamp.dart';

Lamp lamp1 = Lamp(id: 'lamp1', lightLevel: 0.5);
Lamp lamp2 = Lamp(id: 'lamp2', lightLevel: 1);
Lamp lamp3 = Lamp(id: 'lamp3', lightLevel: 0);

class LampList extends StatelessWidget {
  final List<Lamp> lamps = [lamp1, lamp2, lamp3];

  LampList({
    super.key,
    //required ValueNotifier<String> themeNotifier,
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
