import 'point.dart';

class PathResult {
  final String id;
  final List<Point> steps;

  const PathResult({required this.id, required this.steps});

  factory PathResult.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'] as List<dynamic>? ?? const <dynamic>[];
    return PathResult(
      id: json['id']?.toString() ?? '',
      steps: rawSteps
          .map((entry) => Point.fromJson(entry as Map<String, dynamic>))
          .toList(),
    );
  }

  String get displayPath =>
      steps.map((point) => '(${point.x}.${point.y})').join(' -> ');

  String get apiPath =>
      steps.map((point) => '(${point.x},${point.y})').join('->');

  Map<String, dynamic> toApiPayload() {
    return {
      'id': id,
      'result': {
        'steps': steps.map((point) => point.toJson()).toList(),
        'path': apiPath,
      },
    };
  }
}
