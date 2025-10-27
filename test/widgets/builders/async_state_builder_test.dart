// lib/test/widgets/builders/async_state_builder_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/data_state.dart';
import 'package:mobile_strop_app/src/core/core_domain/errors/failures.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

void main() {
  group('AsyncStateBuilder Widget Tests', () {
    testWidgets('shows loading state', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncStateBuilder<String>(
              state: const DataState.loading(),
              builder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows success state with data', (WidgetTester tester) async {
      // ARRANGE
      const testData = 'Test Data';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncStateBuilder<String>(
              state: const DataState.success(testData),
              builder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(testData), findsOneWidget);
    });

    testWidgets('shows error state', (WidgetTester tester) async {
      // ARRANGE
      const errorMessage = 'Test Error';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncStateBuilder<String>(
              state: DataState.error(
                UnexpectedFailure(message: errorMessage),
              ),
              builder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows empty state with custom message', (WidgetTester tester) async {
      // ARRANGE
      const emptyMessage = 'No data available';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncStateBuilder<List<String>>(
              state: const DataState.success([]),
              emptyMessage: emptyMessage,
              builder: (context, data) => ListView(
                children: data.map((s) => Text(s)).toList(),
              ),
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(emptyMessage), findsOneWidget);
    });

    testWidgets('handles retry on error', (WidgetTester tester) async {
      // ARRANGE
      var retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncStateBuilder<String>(
              state: DataState.error(
                UnexpectedFailure(message: 'Test Error'),
              ),
              onRetry: () {
                retryPressed = true;
              },
              builder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      // ACT
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();

      // ASSERT
      expect(retryPressed, isTrue);
    });

    testWidgets('supports custom loading widget', (WidgetTester tester) async {
      // ARRANGE
      const testKey = Key('custom-loading');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncStateBuilder<String>(
              state: const DataState.loading(),
              loadingBuilder: (context) => Container(key: testKey),
              builder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('supports custom error widget', (WidgetTester tester) async {
      // ARRANGE
      const testKey = Key('custom-error');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncStateBuilder<String>(
              state: DataState.error(
                UnexpectedFailure(message: 'Test Error'),
              ),
              errorBuilder: (context, error) => Container(key: testKey),
              builder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('supports custom empty widget', (WidgetTester tester) async {
      // ARRANGE
      const testKey = Key('custom-empty');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AsyncStateBuilder<List<String>>(
              state: const DataState.success([]),
              emptyBuilder: (context) => Container(key: testKey),
              builder: (context, data) => ListView(
                children: data.map((s) => Text(s)).toList(),
              ),
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byKey(testKey), findsOneWidget);
    });
  });
}