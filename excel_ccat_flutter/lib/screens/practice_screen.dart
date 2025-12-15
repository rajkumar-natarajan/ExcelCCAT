import 'package:flutter/material.dart';
import '../models/question.dart';
import '../data/question_data_manager.dart';
import 'test_session_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  CCATLevel _selectedLevel = CCATLevel.level12;
  Language _selectedLanguage = Language.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConfigurationCard(),
          const SizedBox(height: 24),
          Text(
            'Select Test Type',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildTestTypeCard(
            context,
            TestType.quickAssessment,
            Icons.timer_outlined,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildTestTypeCard(
            context,
            TestType.standardPractice,
            Icons.assignment_outlined,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildTestTypeCard(
            context,
            TestType.fullMock,
            Icons.quiz_outlined,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CCATLevel>(
              value: _selectedLevel,
              decoration: const InputDecoration(
                labelText: 'Grade Level',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              items: CCATLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLevel = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Language>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              items: Language.values.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text('${lang.flag} ${lang.displayName}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestTypeCard(
    BuildContext context,
    TestType type,
    IconData icon,
    Color color,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _startTest(type),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${type.defaultQuestionCount} Questions • ${type.defaultTimeMinutes} Minutes',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _startTest(TestType type) {
    final config = TestConfiguration(
      testType: type,
      level: _selectedLevel,
    );

    final questions = QuestionDataManager().getConfiguredQuestions(
      config,
      _selectedLanguage,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestSessionScreen(
          configuration: config,
          questions: questions,
          language: _selectedLanguage,
        ),
      ),
    );
  }
}
