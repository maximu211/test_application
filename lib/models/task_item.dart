import 'point.dart';

class TaskItem {
  final String id;
  final List<String> field;
  final Point start;
  final Point end;

  const TaskItem({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final field = (json['field'] as List<dynamic>).map((row) => row.toString()).toList();

    return TaskItem(
      id: json['id'].toString(),
      field: field,
      start: Point.fromJson(json['start'] as Map<String, dynamic>),
      end: Point.fromJson(json['end'] as Map<String, dynamic>),
    );
  }

  int get width => field.isEmpty ? 0 : field.first.length;
  int get height => field.length;

  bool contains(Point point) =>
      point.y >= 0 && point.y < height && point.x >= 0 && point.x < width;

  String cellAt(Point point) {
    if (!contains(point)) return '';
    return field[point.y][point.x];
  }
}
