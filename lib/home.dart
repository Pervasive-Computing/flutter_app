import 'dart:math';

import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/lamp_component.dart';
import 'widgets/sim_visualiser.dart';
import 'widgets/header.dart';
import 'logger.dart';
import 'widgets/sidebar.dart';

import 'components/lamp.dart';
import 'widgets/lamp_data_view.dart';
import 'widgets/lamp_list_view.dart';
import 'misc/network_utils.dart';
import 'widgets/zoom_buttons.dart';

class Home extends StatefulWidget {
  final ValueNotifier<Flavor> themeNotifier;

  const Home({
    super.key,
    required this.themeNotifier,
  });

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  // final ValueNotifier<String> _themeNotifier;
  late final SimVisualiser _simulation;
  final GlobalKey<SidebarState> sidebarKey = GlobalKey<SidebarState>();
  final GlobalKey<LampDataViewState> lampDataKey = GlobalKey<LampDataViewState>();
  final ValueNotifier<bool> sidebarNotifier = ValueNotifier(false);

  final double headerHeight = 70;
  final double padding = 10;

  double windowWidth = 0;
  double windowHeight = 0;
  double sidebarHeight = 0;
  double sidebarWidth = 0;

  List<Lamp> lamps = [];
  final PageController controller =
      PageController(initialPage: 0, viewportFraction: 0.999); //very bad, very hacky

  @override
  void initState() {
    super.initState();
    _simulation = SimVisualiser();
    _loadLamps().then((value) {
      _simulation.rawLamps = lamps;
      _simulation.addLampSelectCallback(
        (LampComponent lampComponent) {
          openLampDataView(lampComponent.lamp.id);
        },
      );
      _simulation.addLampDeselectCallback(
        (LampComponent lampComponent) {
          closeLampDataView();
        },
      );
    });
    // _simulation.rawLamps = lamps;
    // l.d("lamps: ${lamps.length}");

    // setstate with window width and height
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        windowHeight = MediaQuery.of(context).size.height;
        windowWidth = MediaQuery.of(context).size.width;
      });
    });
  }

  // Async function to load data
  Future<void> _loadLamps() async {
    var l = await NetworkUtils.lampsFromXml("assets/xml/lamp.xml");
    // _simulation.rawLamps = l;
    // Update the state if needed after loading the data
    setState(() {
      // Update your state based on the loaded data
      lamps = l;
    });
  }

  void openLampDataView(String lampId) {
    l.d("openLampDataView");
    for (var lamp in lamps) {
      if (lamp.id == lampId) {
        lampDataKey.currentState?.updateContent(lamp);
        controller.jumpToPage(2);
        sidebarKey.currentState?.openSidebar();
        break;
      }
    }
  }

  void closeLampDataView() {
    controller.jumpToPage(1);
    sidebarKey.currentState?.closeSidebar();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _simulation.context = context;
    _simulation.setColors();

    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    sidebarHeight = windowHeight - padding * 3 - headerHeight;
    sidebarWidth = min(windowWidth - padding * 2, 500);
    sidebarKey.currentState?.height = sidebarHeight;
    sidebarKey.currentState?.width = sidebarWidth;

    return Container(
      constraints: BoxConstraints(
        maxHeight: windowHeight,
        maxWidth: windowWidth,
      ),
      color: theme.colorScheme.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(
            game: _simulation,
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Header(
                  themeNotifier: widget.themeNotifier,
                  onMenuPressed: () {
                    sidebarKey.currentState?.toggleSidebar();
                  },
                  sidebarNotifier: sidebarNotifier,
                  onToggleBuildingsPressed: () {
                    _simulation.animateToggleBuildings();
                  },
                  onToggleCarsPressed: () {
                    _simulation.animateToggleCars();
                  },
                  onToggleLampsPressed: () {
                    _simulation.animateToggleLamps();
                  },
                ),
                Sidebar(
                  key: sidebarKey,
                  stateNotifier: sidebarNotifier,
                  height: sidebarHeight,
                  width: 500,
                  top: headerHeight + padding,
                  extraMovement: padding,
                  child: PageView(
                    /// [PageView.scrollDirection] defaults to [Axis.horizontal].
                    /// Use [Axis.vertical] to scroll vertically.
                    controller: controller,
                    children: [
                      LampListView(
                        lamps: lamps,
                        onPressed: (int index) {
                          controller.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          lampDataKey.currentState?.updateContent(lamps[index]);
                        },
                      ),
                      LampDataView(
                        key: lampDataKey,
                        onPressed: () {
                          controller.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ZoomButtons(
                  onZoomInPressed: () {
                    _simulation.zoomIn();
                  },
                  onZoomOutPressed: () {
                    _simulation.zoomOut();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
