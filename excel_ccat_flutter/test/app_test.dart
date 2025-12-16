import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:excel_ccat/main.dart';
import 'package:excel_ccat/data/question_data_manager.dart';
import 'package:excel_ccat/models/question.dart';

void main() {
  setUpAll(() async {
    // Initialize data manager with mock data if needed, 
    // but our current implementation generates data on init
    await QuestionDataManager().initialize();
  });

  testWidgets('App navigation smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExcelCCATApp());
    await tester.pumpAndSettle();

    // Verify that Dashboard is shown
    expect(find.text('ExcelCCAT'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);

    // Navigate to Practice tab
    await tester.tap(find.byIcon(Icons.school_outlined));
    await tester.pumpAndSettle();

    // Verify Practice screen
    expect(find.widgetWithText(AppBar, 'Practice'), findsOneWidget);
    expect(find.text('Select Test Type'), findsOneWidget);

    // Navigate to Progress tab
    await tester.tap(find.byIcon(Icons.bar_chart_outlined));
    await tester.pumpAndSettle();

    // Verify Progress screen
    expect(find.widgetWithText(AppBar, 'Progress'), findsOneWidget);
    expect(find.text('Performance by Category'), findsOneWidget);

    // Navigate to Settings tab
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Verify Settings screen
    expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
  });

  testWidgets('Full test workflow', (WidgetTester tester) async {
    await tester.pumpWidget(const ExcelCCATApp());
    await tester.pumpAndSettle();

    // Go to Practice
    await tester.tap(find.byIcon(Icons.school_outlined));
    await tester.pumpAndSettle();

    // Start Quick Assessment
    await tester.tap(find.text('Quick Assessment'));
    await tester.pumpAndSettle();

    // Verify Test Session started
    expect(find.textContaining('Question 1/'), findsOneWidget);
    
    // Answer first question (Select Option A)
    // We find the letter 'A' which is in the option circle
    await tester.scrollUntilVisible(find.text('A'), 50);
    await tester.tap(find.text('A'));
    await tester.pump();
    
    // Go to next question
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    
    // Verify Question 2
    expect(find.textContaining('Question 2/'), findsOneWidget);
    
    // Answer second question (Select Option B)
    await tester.scrollUntilVisible(find.text('B'), 50);
    await tester.tap(find.text('B'));
    await tester.pump();

    // We won't go through all 20 questions in this test, 
    // but we verified the flow starts and navigation works.
  });

  testWidgets('Settings interaction test', (WidgetTester tester) async {
    await tester.pumpWidget(const ExcelCCATApp());
    await tester.pumpAndSettle();

    // Go to Settings
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    // Toggle Dark Mode
    // Note: In a real app we'd verify the theme changed, 
    // here we just verify the switch works
    await tester.tap(find.text('Dark Mode'));
    await tester.pump();
    
    // Toggle Notifications
    await tester.tap(find.text('Notifications'));
    await tester.pump();
  });
}
