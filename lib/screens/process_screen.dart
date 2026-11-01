import 'package:flutter/material.dart';

import '../models/path_result.dart';
import '../models/task_item.dart';
import '../services/api_service.dart';
import '../services/path_finder.dart';
import 'results_screen.dart';

class ProcessScreen extends StatefulWidget {
  final String url;
  final List<TaskItem> tasks;

  const ProcessScreen({
    super.key,
    required this.url,
    required this.tasks,
  });

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  final ApiService _apiService = const ApiService();
  final PathFinder _pathFinder = PathFinder();
  bool _isCalculating = true;
  bool _isSending = false;
  double _progress = 0;
  List<PathResult> _results = const <PathResult>[];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _calculateResults();
  }

  Future<void> _calculateResults() async {
    final results = <PathResult>[];

    for (var index = 0; index < widget.tasks.length; index++) {
      final task = widget.tasks[index];
      final steps = _pathFinder.findPath(task.field, task.start, task.end);
      results.add(
        PathResult(
          id: task.id,
          steps: steps,
        ),
      );

      if (!mounted) return;

      setState(() {
        _results = List<PathResult>.from(results);
        _progress = (index + 1) / widget.tasks.length;
      });

      await Future<void>.delayed(const Duration(milliseconds: 80));
    }

    if (mounted) {
      setState(() {
        _isCalculating = false;
      });
    }
  }

  Future<void> _sendResults() async {
    if (_results.isEmpty) {
      return;
    }

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      await _apiService.sendResults(widget.url, _results);
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            results: _results,
            tasks: widget.tasks,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Processing results')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isCalculating) ...[
                    const Icon(Icons.calculate_rounded, size: 64),
                    const SizedBox(height: 20),
                    const Text(
                      'Calculating shortest paths',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 24),
                    LinearProgressIndicator(value: _progress == 0 ? null : _progress),
                    const SizedBox(height: 16),
                    Text(
                      '$percent% complete',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ] else ...[
                    const Icon(Icons.check_circle_outline_rounded, size: 64, color: Colors.green),
                    const SizedBox(height: 20),
                    const Text(
                      'All results are ready',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isSending ? null : _sendResults,
                      icon: _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload_rounded),
                      label: Text(_isSending ? 'Sending results...' : 'Send results to server'),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
