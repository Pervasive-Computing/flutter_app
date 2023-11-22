class Lamp {
  final double lightLevel; // 0 = fully off, 1 = fully on
  final String id;

  const Lamp({
    required this.id,
    this.lightLevel = 0,
  });
}
