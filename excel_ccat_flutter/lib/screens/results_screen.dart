import 'package:flutter/material.dart';
import '../models/question.dart';

class ResultsScreen extends StatelessWidget {
  final TestResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildScoreCard(context),
          const SizedBox(height: 24),
          Text(
            'Performance Breakdown',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildBreakdownList(context),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context) {
    final percentage = result.percentage;
    final color = _getScoreColor(percentage);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 12,
                    backgroundColor: color.withOpacity(0.1),
                    color: color,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${percentage.toInt()}%',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Score',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Correct',
                  '${result.correctAnswers}/${result.totalQuestions}',
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  'Time',
                  _formatDuration(result.totalTime),
                  Colors.blue,
                ),
                _buildStatItem(
                  context,
                  'Percentile',
                  '${result.percentile}th',
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildBreakdownList(BuildContext context) {
    return Column(
      children: result.scoreByType.entries.map((entry) {
        final type = entry.key;
        final score = entry.value;
        // Calculate total questions for this type from answers
        final total = result.answers.where((a) {
          // This is a bit inefficient, but works for now. 
          // Ideally we'd pass the questions list or store type in answer
          // For now, let's just assume we can get it from the score map logic
          // Actually, we can't easily get total per type from just scoreByType map
          // Let's iterate answers and count
          return true; // Placeholder
        }).length; 
        
        // Better approach: Count totals from answers by looking up question type?
        // Since we don't have questions list here easily without passing it,
        // let's just show the raw score for now.
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(_getIconForType(type)),
            title: Text(type.displayName),
            trailing: Text(
              '$score correct',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForType(QuestionType type) {
    switch (type) {
      case QuestionType.verbal:
        return Icons.chat_bubble_outline;
      case QuestionType.quantitative:
        return Icons.calculate_outlined;
      case QuestionType.nonVerbal:
        return Icons.grid_view;
    }
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
