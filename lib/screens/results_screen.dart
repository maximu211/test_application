import 'package:flutter/material.dart';

import '../models/path_result.dart';
import '../models/task_item.dart';
import 'result_detail_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<TaskItem> tasks;
  final List<PathResult> results;

  const ResultsScreen({
    super.key,
    required this.tasks,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shortest paths'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final result = results[index];
          final task = tasks.firstWhere(
            (item) => item.id == result.id,
            orElse: () => tasks[index],
          );

          return Card(
            child: ListTile(
              title: Text(result.displayPath),
              subtitle: Text('Task ID: ${result.id}'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ResultDetailScreen(
                      task: task,
                      result: result,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
