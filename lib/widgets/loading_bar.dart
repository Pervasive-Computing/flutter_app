import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'glass.dart';
// import '../logger.dart';
import '../themes/catppuccin_theme.dart';

class LoadingBar extends StatefulWidget {
  final double progress;

  const LoadingBar({
    super.key,
    this.progress = 0,
  });

  @override
  State<LoadingBar> createState() => LoadingBarState();
}

class LoadingBarState extends State<LoadingBar> {
  late double _progress;

  void setProgress(double newProgress) {
    setState(() {
      _progress = newProgress;
    });
  }

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onColor = theme.extension<LampTheme>()!.lampColor!.withOpacity(0.5);
    final offColor = theme.extension<LampTheme>()!.offColor!.withOpacity(0.5);

    return Container(
      height: 30,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: theme.colorScheme.onBackground,
        ), // Outline color
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _progress,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.lerp(offColor, onColor, _progress)!,
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }
}
