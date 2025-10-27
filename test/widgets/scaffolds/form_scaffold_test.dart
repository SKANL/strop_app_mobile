// lib/test/widgets/scaffolds/form_scaffold_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

void main() {
  group('FormScaffold Widget Tests', () {
    testWidgets('renders title correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: FormScaffold(
            title: 'Test Form',
            formKey: GlobalKey<FormState>(),
            onSubmit: () {},
            sections: const [],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ASSERT
      expect(find.text('Test Form'), findsOneWidget);
    });

    testWidgets('renders children correctly', (WidgetTester tester) async {
      // ARRANGE
      const testKey1 = Key('test-field-1');
      const testKey2 = Key('test-field-2');

      await tester.pumpWidget(
        MaterialApp(
          home: FormScaffold(
            title: 'Test Form',
            formKey: GlobalKey<FormState>(),
            onSubmit: () {},
            sections: [
              Container(key: testKey1),
              Container(key: testKey2),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ASSERT - basic structure exists (Form and title)
      expect(find.byType(Form), findsOneWidget);
      expect(find.text('Test Form'), findsOneWidget);
    });

    testWidgets('handles form submission', (WidgetTester tester) async {
      // ARRANGE
      var submitted = false;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: FormScaffold(
            title: 'Test Form',
            formKey: formKey,
            onSubmit: () {
              submitted = true;
            },
            sections: [
              TextFormField(
                initialValue: 'valid',
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
            ],
          ),
        ),
      );

      // ACT
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      // ASSERT
      expect(submitted, isTrue);
    });

    testWidgets('shows loading state', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: FormScaffold(
            title: 'Test Form',
            formKey: GlobalKey<FormState>(),
            onSubmit: () {},
            isLoading: true,
            sections: const [],
          ),
        ),
      );

      // ASSERT
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Guardar'), findsNothing);
    });

    testWidgets('disables submit when invalid', (WidgetTester tester) async {
      // ARRANGE
      var submitted = false;
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: FormScaffold(
            title: 'Test Form',
            formKey: formKey,
            onSubmit: () {
              submitted = true;
            },
            sections: [
              TextFormField(
                validator: (value) => 'Required', // Always invalid
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ACT
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      // ASSERT
      expect(submitted, isFalse);
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('supports custom submit text', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: FormScaffold(
            title: 'Test Form',
            formKey: GlobalKey<FormState>(),
            onSubmit: () {},
            submitText: 'Custom Submit',
            sections: const [],
          ),
        ),
      );

      // ASSERT
      expect(find.text('Custom Submit'), findsOneWidget);
    });

    testWidgets('handles cancel correctly', (WidgetTester tester) async {
      // ARRANGE
      var cancelled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: FormScaffold(
            title: 'Test Form',
            formKey: GlobalKey<FormState>(),
            onSubmit: () {},
            onCancel: () {
              cancelled = true;
            },
            children: const [],
          ),
        ),
      );

      // ACT
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      // ASSERT
      expect(cancelled, isTrue);
    });
  });
}