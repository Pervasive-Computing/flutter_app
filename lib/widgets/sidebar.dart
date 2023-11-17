import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';
import 'glass.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  bool isSidebarOpen = false;

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
    return Glass(
      padding: const EdgeInsets.all(30),
      width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sidebar',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
      ),
    );
  }
}
