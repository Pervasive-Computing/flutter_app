// ignore_for_file: avoid_print

import 'dart:io';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';
import 'package:path/path.dart' as p;

// print
void main() {
  // xml file: sumo/katrinebjerg.net.xml
  // final pathNet = p.join(Directory.current.path, 'misc/sumo/katrinebjerg.net.xml');
  // print(pathNet);

  // final fileNet = File(pathNet);
  // final documentNet = XmlDocument.parse(fileNet.readAsStringSync());

  // final out = document.findAllElements("edge");
  // final out = documentNet.xpath("net/edge/lane/@shape");

  final pathPoly = p.join(Directory.current.path, 'misc/sumo/horsens.lamp');

  final filePoly = File(pathPoly);
  final documentPoly = XmlDocument.parse(filePoly.readAsStringSync());

  final out = documentPoly.xpath("osm/node");

  // Set types = {};

  for (var e in out) {
    print(e.children);
    // make into map recursively into children
    var map = {};

    for (var e in e.attributes) {
      map.addAll({e.name.toXmlString(): e.value});
    }

    var childList = [];
    var children = e.children;
    for (int c = 0; c < children.length; c++) {
      var child = children[c];
      var childMap = {};
      for (var e in child.attributes) {
        childMap.addAll({e.name.toXmlString(): e.value});
      }
      childList.add(childMap);
      // map.addAll({"child.${child.nodeType}.$c": childMap});
    }

    map.addAll({"children": childList});
    map = map.cast<String, dynamic>();

    print(map);

    // var map = {};
    // for (var e in e.attributes) {
    //   map.addAll({e.name.toXmlString(): e.value});
    // }

    // map = map.cast<String, String>();

    // print(map);

    // var thing = map["type"];
    // print(thing);
    // types.add(thing);

    // print((map.cast<String, String>())["type"]);
  }

  // print(types);

  // print(document.xpath("net/edge"));
}
