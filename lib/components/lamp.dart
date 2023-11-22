class Lamp {
  double lightLevel; // 0 = fully off, 1 = fully on
  String id;

  Lamp({
    required this.id,
    this.lightLevel = 0,
  });
}
