/// Область на карте в виде прямоугольника (градусы).
class GeoRect {
  final double south;
  final double north;
  final double west;
  final double east;

  const GeoRect({
    required this.south,
    required this.north,
    required this.west,
    required this.east,
  });

  factory GeoRect.fromMap(Map<String, dynamic> map) => GeoRect(
    south: (map['south'] as num).toDouble(),
    north: (map['north'] as num).toDouble(),
    west: (map['west'] as num).toDouble(),
    east: (map['east'] as num).toDouble(),
  );

  Map<String, dynamic> toMap() => {
    'south': south,
    'north': north,
    'west': west,
    'east': east,
  };

  String get label =>
      'широта $south…$north°, долгота $west…$east°';
}
