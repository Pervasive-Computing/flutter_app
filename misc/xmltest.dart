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

  final pathPoly = p.join(Directory.current.path, 'misc/sumo/katrinebjerg.poly.xml');

  final filePoly = File(pathPoly);
  final documentPoly = XmlDocument.parse(filePoly.readAsStringSync());

  final out = documentPoly.xpath("additional/poly");

  Set types = {};

  for (var e in out) {
    var map = {};
    for (var e in e.attributes) {
      map.addAll({e.name.toXmlString(): e.value});
    }

    map = map.cast<String, String>();

    types.add(map["type"]);

    // print((map.cast<String, String>())["type"]);
  }

  print(types);

  // print(document.xpath("net/edge"));
}
