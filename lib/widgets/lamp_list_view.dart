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
    return ListView.builder(
      itemCount: lamps.length,
      itemBuilder: (context, index) {
        return LampItem(
          lamp: lamps[index],
          onClick: () {
            //l.d("I clicked item");
            onPressed(index);
            //print('Clicked on ${lamps[index]}');
          },
        );
      },
    );
  }
}
