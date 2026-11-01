class Point {
  final int x;
  final int y;

  const Point({required this.x, required this.y});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
    );
  }

  Map<String, int> toJson() => {'x': x, 'y': y};

  Point copyWith({int? x, int? y}) => Point(x: x ?? this.x, y: y ?? this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';
}
