import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import '../websocket/simulation_api.dart';
import '../themes/catppuccin_theme.dart';
import '../logger.dart';

class Graph extends StatefulWidget {
  const Graph({
    super.key,
  });

  @override
  State<Graph> createState() => GraphState();
}

class GraphState extends State<Graph> {
  // final simStartingTime = DateTime.parse("2023-12-14T22:00:00Z");
  // final startingTime = DateTime.now();
  late DateTime simTimeNow;
  List<Map<Object, Object>> _data = [];

  void setData(List<dynamic> values) {
    // l.d("Setting data: $values");
    // setTime();
    simTimeNow = SimulationAPI.getSimTimeNow();
    int remainingLenght = SimulationAPI.lampDataLength - values.length;
    // l.d("Remaining length: $remainingLenght");
    List<dynamic> paddedValues = List.filled(remainingLenght, 0.0, growable: true);
    paddedValues.addAll(values);
    // l.d("Padded values: $paddedValues");

    final dataObj = paddedValues.asMap().entries.map((e) {
      // l.d("e: $e, ${e.runtimeType}");
      int timeStep = e.key + 1;
      double lightlevel = (e.value + 0.0) * 100;

      // l.d("TimeStep: $timeStep, Lightlevel: $lightlevel");

      return {'time': timeStep, 'lightlevel': lightlevel};
    }).toList();

    setState(() {
      _data = dataObj;
    });
  }

  @override
  void initState() {
    super.initState();
    simTimeNow = SimulationAPI.getSimTimeNow();
    setData([]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chart(
      data: _data,
      variables: {
        'time': Variable(
          accessor: (Map map) => map['time'] as num,
          scale: LinearScale(
              min: 0,
              max: SimulationAPI.lampDataLength + .99,
              tickCount: SimulationAPI.lampDataLength,
              formatter: (number) {
                if (number % 2 == 1) {
                  return '';
                }
                int offset = simTimeNow.minute - SimulationAPI.lampDataLength;
                int numb = (offset < 0 ? 60 + offset : offset) + number.toInt();
                return (numb % 60).floor().toString();
              }),
        ),
        'lightlevel': Variable(
          accessor: (Map map) => map['lightlevel'] as num,
          scale: LinearScale(
              min: 0,
              max: 100,
              tickCount: 5,
              formatter: (number) {
                return '${number.floor()}%';
              }),
        ),
      },
      marks: [
        IntervalMark(
          color: ColorEncode(
            value: theme.extension<LampTheme>()!.lampColor!, // Replace with your desired color
          ),
          shape: ShapeEncode<IntervalShape>(
            value: RectShape(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
        ),
      ],
      axes: [
        AxisGuide(
          label: LabelStyle(
              offset: const Offset(7.5, 2.0),
              textStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
        ),
        AxisGuide(
          label: LabelStyle(
            offset: const Offset(-16.0, 0.0),
            textStyle: theme.textTheme.bodyLarge?.copyWith(fontSize: 14),
          ),
          grid: PaintStyle(
            strokeColor: theme.colorScheme.onBackground,
          ),
        ),
      ],
    );
  }
}
