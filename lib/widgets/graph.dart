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
  List<Map<Object, Object>> _data = [
    {'hour': 0, 'lightlevel': 0}
  ];

  _mockupData() async {
    //GET THE DATA
    const dataObj = [
      {'hour': 1, 'lightlevel': 70},
      {'hour': 2, 'lightlevel': 60},
      {'hour': 3, 'lightlevel': 20},
      {'hour': 4, 'lightlevel': 10},
      {'hour': 5, 'lightlevel': 30},
      {'hour': 6, 'lightlevel': 70},
      {'hour': 7, 'lightlevel': 60},
      {'hour': 8, 'lightlevel': 20},
      {'hour': 9, 'lightlevel': 10},
      {'hour': 10, 'lightlevel': 30},
      {'hour': 11, 'lightlevel': 70},
      {'hour': 12, 'lightlevel': 60},
      {'hour': 13, 'lightlevel': 20},
      {'hour': 14, 'lightlevel': 10},
      {'hour': 15, 'lightlevel': 30},
      {'hour': 16, 'lightlevel': 70},
      {'hour': 17, 'lightlevel': 60},
      {'hour': 18, 'lightlevel': 20},
      {'hour': 19, 'lightlevel': 10},
      {'hour': 20, 'lightlevel': 30},
      {'hour': 21, 'lightlevel': 70},
      {'hour': 22, 'lightlevel': 60},
      {'hour': 23, 'lightlevel': 20},
      {'hour': 24, 'lightlevel': 10},
    ];

    setState(() {
      _data = dataObj;
    });
  }

  void setData(List<double> values) {
    final dataObj = values.asMap().entries.map((e) {
      int hour = e.key + 1;
      double lightlevel = e.value;

      return {'hour': hour, 'lightlevel': lightlevel};
    }).toList();

    l.d("dataObj: $dataObj");

    setState(() {
      _data = dataObj;
    });
  }

  @override
  void initState() {
    super.initState();
    _mockupData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chart(
      data: _data,
      variables: {
        'hour': Variable(
          accessor: (Map map) => map['hour'] as num,
          scale: LinearScale(
              min: 0,
              max: 24.99,
              tickCount: 24,
              formatter: (number) {
                if (number % 2 == 1) {
                  return '';
                }
                return number.floor().toString();
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
