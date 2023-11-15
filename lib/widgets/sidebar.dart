import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

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
    return GlassContainer(
      padding: const EdgeInsets.all(30),
      height: double.infinity,
      width: 400,
      blur: 15,
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      borderWidth: 2,
      // borderColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75),
      // color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.20),
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.10),
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.3)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.39, 0.40, 1.0],
      ),
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
