import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lighter/app_state.dart';
import 'package:lighter/features/today/custom_tasks.dart';

void main() {
  testWidgets('unified template library includes health and custom tasks', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dailyTasksProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, child) => Center(
                child: FilledButton(
                  onPressed: () => showAddTaskFlow(context, ref),
                  child: const Text('Add a task'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add a task'), findsOneWidget);
    await tester.tap(find.text('Add a task'));
    await tester.pumpAndSettle();

    expect(find.text('Add a daily task'), findsOneWidget);
    expect(find.text('Create a custom task'), findsOneWidget);
    expect(find.text('Water'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Steps'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Running'),
      240,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Running'), findsOneWidget);
  });
}
