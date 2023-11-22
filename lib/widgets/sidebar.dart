import 'package:flutter/material.dart';
import 'glass.dart';
import '../logger.dart';
import 'circle_icon_button.dart';
import 'lamp_list_view.dart';
import 'lamp_data_view.dart';

class Sidebar extends StatefulWidget {
  final double height;
  final double width;
  final double top;
  final Duration duration;
  final bool animateOpacity;
  final double extraMovement;
  final Widget child;

  const Sidebar({
    super.key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.top = 0,
    this.duration = const Duration(milliseconds: 200),
    this.animateOpacity = false,
    this.extraMovement = 0,
    required this.child,
  });

  @override
  State<Sidebar> createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  bool _isSidebarOpen = false;
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
      _isSidebarOpen = true;
    });
    l.d("_isSidebarOpen: $_isSidebarOpen");
  }

  void closeSidebar() {
    setState(() {
      _isSidebarOpen = false;
    });
    l.d("_isSidebarOpen: $_isSidebarOpen");
  }

  void toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
    l.d("_isSidebarOpen: $_isSidebarOpen");
  }

  bool getState() {
    return _isSidebarOpen;
  }

  // do something on state change
  void onStateChange() {
    l.d("_isSidebarOpen: $_isSidebarOpen");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.duration,
      curve: standardEasing,
      left: _isSidebarOpen ? 0 : -(width + widget.extraMovement),
      top: widget.top,
      child: AnimatedOpacity(
        opacity: widget.animateOpacity ? (_isSidebarOpen ? 1.0 : 0) : 1.0,
        duration: widget.duration,
        child: Glass(
          padding: const EdgeInsets.all(30),
          width: width,
          height: height,
          child: widget.child,
        ),
      ),
    );
  }
}
