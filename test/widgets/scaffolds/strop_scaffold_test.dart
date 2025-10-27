// lib/test/widgets/scaffolds/strop_scaffold_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

void main() {
  group('StropScaffold Widget Tests', () {
    testWidgets('renders title correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: StropScaffold(
            title: 'Test Title',
            body: const SizedBox(),
          ),
        ),
      );

      // ASSERT
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders actions correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: StropScaffold(
            title: 'Test',
            actions: [
              IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
            ],
            body: const SizedBox(),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('renders leading icon correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: StropScaffold(
            title: 'Test',
            leading: const Icon(Icons.arrow_back),
            body: const SizedBox(),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders body correctly', (WidgetTester tester) async {
      // ARRANGE
      const testKey = Key('test-body');
      await tester.pumpWidget(
        MaterialApp(
          home: StropScaffold(
            title: 'Test',
            body: Container(key: testKey),
          ),
        ),
      );

      // ASSERT
      expect(find.byKey(testKey), findsOneWidget);
    });

    testWidgets('renders FAB correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: StropScaffold(
            title: 'Test',
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            body: const SizedBox(),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('supports custom background color', (WidgetTester tester) async {
      // ARRANGE
      const customColor = Color(0xFFE0E0E0);
      await tester.pumpWidget(
        MaterialApp(
          home: StropScaffold(
            title: 'Test',
            backgroundColor: customColor,
            body: const SizedBox(),
          ),
        ),
      );

      // ASSERT
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(customColor));
    });
  });
}