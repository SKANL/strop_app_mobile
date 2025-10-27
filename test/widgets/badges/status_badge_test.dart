// lib/test/widgets/badges/status_badge_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

void main() {
  group('StatusBadge Widget Tests', () {
    testWidgets('renders basic badge correctly', (WidgetTester tester) async {
      // ARRANGE
      const label = 'Test Badge';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: label,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              icon: Icons.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(label), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('renders incident status badge correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge.incidentStatus(
              status: 'abierta',
              isCritical: false,
              upperCase: true,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text('ABIERTA'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    });

    testWidgets('renders critical incident badge correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge.incidentStatus(
              status: 'abierta',
              isCritical: true,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text('🔥 abierta (CRÍTICA)'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('renders approval status badge correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge.approvalStatus(
              status: 'aprobada',
              upperCase: true,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text('SOLICITUD APROBADA'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('renders incident type badge correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge.incidentType(
              type: 'avance',
              useSoftColors: true,
            ),
          ),
        ),
      );

  // ASSERT
  expect(find.text('AVANCE'), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('renders outlined badge correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: 'Test',
              isOutlined: true,
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      // ASSERT
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
      expect(decoration.color, isNull);
    });

    testWidgets('handles upper case transformation', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: 'test',
              upperCase: true,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text('TEST'), findsOneWidget);
    });

    testWidgets('applies soft colors correctly', (WidgetTester tester) async {
      // ARRANGE
      const baseColor = Colors.blue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              label: 'test',
              backgroundColor: baseColor,
              useSoftColors: true,
            ),
          ),
        ),
      );

      // ASSERT
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(equals(baseColor)));
      expect(decoration.color?.computeLuminance(), greaterThan(baseColor.computeLuminance()));
    });
  });
}