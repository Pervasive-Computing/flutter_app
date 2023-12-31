import 'package:flutter/material.dart';
import 'package:flutter_app/websocket/simulation_api.dart';
import '../themes/catppuccin_theme.dart';
import '../components/lamp.dart';
import '../logger.dart';
import 'graph.dart';
import 'circle_icon_button.dart';
import 'loading_bar.dart';

class LampDataView extends StatefulWidget {
  final Lamp lamp = Lamp(
    id: 'NaN',
    lightLevel: 0,
    x: 0,
    y: 0,
  );
  final Function onPressed;

  LampDataView({
    super.key,
    required this.onPressed,
  });

  @override
  State<LampDataView> createState() => LampDataViewState();
}

class LampDataViewState extends State<LampDataView> {
  late Lamp lamp;
  final GlobalKey<LoadingBarState> _loadingBarKey = GlobalKey<LoadingBarState>();
  final GlobalKey<GraphState> _graphKey = GlobalKey<GraphState>();

  @override
  void initState() {
    super.initState();
    lamp = widget.lamp;
    SimulationAPI.addLampsMessageCallback(_updateBar);
  }

  void updateContent(Lamp lamp) {
    setState(() {
      this.lamp = lamp;
    });
    _graphKey.currentState?.setData([]);
    SimulationAPI.reqLampData(lamp.id).then((value) {
      _graphKey.currentState?.setData(value);
    });
    _loadingBarKey.currentState?.setProgress(this.lamp.lightLevel);
  }

  void _updateBar(Map<String, double> lamps) {
    setState(() {});
    _loadingBarKey.currentState?.setProgress(lamp.lightLevel);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleIconButton(
                icon: Icons.chevron_left,
                color: theme.colorScheme.onBackground,
                onPressed: () {
                  widget.onPressed();
                },
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    'Lamp ID: ${lamp.id}',
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    softWrap: true,
                    //overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const SizedBox(width: 54),
              Expanded(
                child: Text(
                  'Current light Level: ${(lamp.lightLevel * 100).floor()}%',
                  style: theme.textTheme.bodyLarge,
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 20),
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.onBackground,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LoadingBar(
                  key: _loadingBarKey,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 30),
          // Expanded(
          //   child: Container(
          //     constraints: const BoxConstraints(maxHeight: 300),
          //     height: double.infinity,
          //     padding: const EdgeInsets.only(
          //         top: 12, bottom: 12, left: 16, right: 12),
          //     child: const Graph(),
          //   ),
          // )
          Container(
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 16,
              right: 12,
            ),
            child: Graph(
              key: _graphKey,
            ),
          ),
        ],
      ),
    );
  }
}
