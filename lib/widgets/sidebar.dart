import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'glass.dart';
import '../logger.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  bool isSidebarOpen = true;

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

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      left: isSidebarOpen ? 0 : -500,
      child: Glass(
        padding: const EdgeInsets.all(30),
        width: 400,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sidebar',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: closeSidebar,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
