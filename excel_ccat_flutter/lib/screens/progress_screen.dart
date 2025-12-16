import 'package:flutter/material.dart';
import '../controllers/smart_learning_controller.dart';
import '../models/question.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final SmartLearningController _smartLearning = SmartLearningController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _smartLearning,
      builder: (context, _) {
        final summary = _smartLearning.getSummary();
        final allStats = _smartLearning.allStats;
        
        return Scaffold(
          appBar: AppBar(title: const Text('Progress')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummaryCard(context, summary),
              const SizedBox(height: 16),
              _buildSmartLearningCard(context, summary),
              const SizedBox(height: 24),
              Text(
                'Performance by Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildCategoryProgress(
                context, 
                'Verbal', 
                _calculateCategoryAccuracy(allStats, QuestionType.verbal),
                Colors.blue,
              ),
              _buildCategoryProgress(
                context, 
                'Quantitative', 
                _calculateCategoryAccuracy(allStats, QuestionType.quantitative),
                Colors.green,
              ),
              _buildCategoryProgress(
                context, 
                'Non-Verbal', 
                _calculateCategoryAccuracy(allStats, QuestionType.nonVerbal),
                Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                'Weak Areas',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildWeakAreasSection(context),
            ],
          ),
        );
      },
    );
  }

  double _calculateCategoryAccuracy(Map<String, PerformanceStats> allStats, QuestionType type) {
    // Get subtypes for this category
    final subtypes = _getSubtypesForType(type);
    int total = 0;
    int correct = 0;
    
    for (final subtype in subtypes) {
      if (allStats.containsKey(subtype)) {
        total += allStats[subtype]!.totalAttempts;
        correct += allStats[subtype]!.correctAttempts;
      }
    }
    
    return total > 0 ? correct / total : 0.0;
  }

  List<String> _getSubtypesForType(QuestionType type) {
    switch (type) {
      case QuestionType.verbal:
        return ['Synonyms', 'Antonyms', 'Analogies'];
      case QuestionType.quantitative:
        return ['Number Analogies', 'Number Series', 'Quantitative Relations'];
      case QuestionType.nonVerbal:
        return ['Figure Analogies', 'Figure Classification', 'Pattern Completion'];
    }
  }

  Widget _buildSummaryCard(BuildContext context, SmartLearningSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(context, 'Attempted', '${summary.totalQuestionsAttempted}'),
            _buildStat(context, 'Mastered', '${summary.masteredCount}'),
            _buildStat(context, 'Bookmarks', '${summary.bookmarkCount}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartLearningCard(BuildContext context, SmartLearningSummary summary) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Smart Learning Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSmartStatTile(
                    context,
                    Icons.warning_amber_rounded,
                    Colors.orange,
                    '${summary.weakAreaCount}',
                    'Weak Areas',
                  ),
                ),
                Expanded(
                  child: _buildSmartStatTile(
                    context,
                    Icons.replay_rounded,
                    Colors.blue,
                    '${summary.reviewDueCount}',
                    'Due for Review',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartStatTile(
    BuildContext context,
    IconData icon,
    Color color,
    String value,
    String label,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeakAreasSection(BuildContext context) {
    final weakAreas = _smartLearning.getWeakSubTypes();
    
    if (weakAreas.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _smartLearning.getSummary().totalQuestionsAttempted > 0
                      ? 'Great job! No weak areas identified. Keep practicing!'
                      : 'Complete some practice tests to identify areas for improvement.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: weakAreas.map((subtype) {
        final stats = _smartLearning.getStats(subtype);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.warning_amber, color: Colors.orange),
            ),
            title: Text(subtype),
            subtitle: Text(
              'Accuracy: ${stats?.accuracy.toStringAsFixed(1)}% (${stats?.correctAttempts}/${stats?.totalAttempts})',
            ),
            trailing: FilledButton.tonal(
              onPressed: () {
                // TODO: Navigate to practice with this subtype
              },
              child: const Text('Practice'),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildCategoryProgress(
    BuildContext context,
    String label,
    double progress,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleMedium),
              Text('${(progress * 100).toInt()}%'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: color.withOpacity(0.1),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
