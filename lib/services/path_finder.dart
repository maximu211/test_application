import '../models/point.dart';

class PathFinder {
  List<Point> findPath(List<String> field, Point start, Point end) {
    if (field.isEmpty || field.first.isEmpty) {
      return const <Point>[];
    }

    if (start == end) {
      return [start];
    }

    final queue = <Point>[start];
    final visited = <Point>{start};
    final parents = <Point, Point>{};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      for (final next in _neighbors(field, current)) {
        if (visited.contains(next)) {
          continue;
        }

        visited.add(next);
        parents[next] = current;

        if (next == end) {
          return _reconstructPath(parents, end);
        }

        queue.add(next);
      }
    }

    return const <Point>[];
  }

  List<Point> _reconstructPath(Map<Point, Point> parents, Point end) {
    final path = <Point>[];
    var current = end;

    while (parents.containsKey(current)) {
      path.add(current);
      current = parents[current]!;
    }

    path.add(current);
    final reversedPath = path.reversed.toList();
    return reversedPath;
  }

  List<Point> _neighbors(List<String> field, Point point) {
    final neighbors = <Point>[];
    final height = field.length;
    final width = field.first.length;

    for (var dy = -1; dy <= 1; dy++) {
      for (var dx = -1; dx <= 1; dx++) {
        if (dx == 0 && dy == 0) {
          continue;
        }

        final nextX = point.x + dx;
        final nextY = point.y + dy;

        if (nextX < 0 || nextX >= width || nextY < 0 || nextY >= height) {
          continue;
        }

        if (field[nextY][nextX] == 'X') {
          continue;
        }

        neighbors.add(Point(x: nextX, y: nextY));
      }
    }

    return neighbors;
  }
}
