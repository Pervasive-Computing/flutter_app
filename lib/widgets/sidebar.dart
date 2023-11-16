import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'glass.dart';
import '../logger.dart';
import 'circle_icon_button.dart';

class Sidebar extends StatefulWidget {
  final double height;
  final double width;
  final double top;

  const Sidebar({
    super.key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.top = 0,
  });

  @override
  State<Sidebar> createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  bool isSidebarOpen = false;
  late double height;
  late double width;

  @override
  void initState() {
    super.initState();
    height = widget.height;
    width = widget.width;
  }

  void openSidebar() {
    setState(() {
      isSidebarOpen = true;
    });
  }

  void closeSidebar() {
    setState(() {
      isSidebarOpen = false;
    });
  }

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: isSidebarOpen ? 0 : -500,
      top: widget.top,
      child: Glass(
        padding: const EdgeInsets.all(30),
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sidebar',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
                ),
                // CircleIconButton(
                //   color: Theme.of(context).colorScheme.onBackground,
                //   icon: Icons.chevron_left,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
