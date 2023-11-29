class Lamp {
  final double lightLevel; // 0 = fully off, 1 = fully on
  final String id;
  final double x;
  final double y;

  const Lamp({
    required this.id,
    required this.x,
    required this.y,
    this.lightLevel = 0,
  });
}
