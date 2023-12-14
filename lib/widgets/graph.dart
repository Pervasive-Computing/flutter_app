import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
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
  List<Map<Object, Object>> _data = [];

  void setData(List<dynamic> values) {
    int remainingLenght = 24 - values.length;
    List<dynamic> paddedValues = List.filled(remainingLenght, 0, growable: true);
    paddedValues.addAll(values);

    final dataObj = paddedValues.asMap().entries.map((e) {
      int minute = e.key + 1;
      double lightlevel = e.value * 100;

      return {'minute': minute, 'lightlevel': lightlevel};
    }).toList();

    setState(() {
      _data = dataObj;
    });
  }

  @override
  void initState() {
    super.initState();
    setData(List<double>.filled(24, 0));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chart(
      data: _data,
      variables: {
        'minute': Variable(
          accessor: (Map map) => map['minute'] as num,
          scale: LinearScale(
              min: 0,
              max: 24.99,
              tickCount: 24,
              formatter: (number) {
                if (number % 2 == 1) {
                  return '';
                }
                var minuteNow = DateTime.now().minute;
                return ((number - minuteNow).abs() % 60).floor().toString();
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
