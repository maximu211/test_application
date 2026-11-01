import 'package:flutter/material.dart';

import '../models/path_result.dart';
import '../models/point.dart';
import '../models/task_item.dart';

class ResultDetailScreen extends StatelessWidget {
  final TaskItem task;
  final PathResult result;

  const ResultDetailScreen({
    super.key,
    required this.task,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final pathSet = result.steps.toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Result details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.displayPath,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Text(
                'Path length: ${result.steps.length} steps',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _GridView(
                  rows: task.field,
                  path: pathSet,
                  start: task.start,
                  end: task.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List<String> rows;
  final Set<Point> path;
  final Point start;
  final Point end;

  const _GridView({
    required this.rows,
    required this.path,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final cellSize = 44.0;
    final width = rows.first.length;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows.length, (y) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(width, (x) {
              final point = Point(x: x, y: y);
              final cell = rows[y][x];
              final isBlocked = cell == 'X';
              final isStart = point == start;
              final isEnd = point == end;
              final isPathCell = path.contains(point);

              Color backgroundColor;
              if (isBlocked) {
                backgroundColor = Colors.black;
              } else if (isStart) {
                backgroundColor = const Color(0xFF64FFDA);
              } else if (isEnd) {
                backgroundColor = const Color(0xFF009688);
              } else if (isPathCell) {
                backgroundColor = const Color(0xFF4CAF50);
              } else {
                backgroundColor = Colors.white;
              }

              final textColor = backgroundColor == Colors.black ? Colors.white : Colors.black;

              return Container(
                width: cellSize,
                height: cellSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '$x.$y',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
