// lib/test/widgets/banners/project_info_banner_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';
import 'package:mobile_strop_app/src/features/incidents/presentation/widgets/project_info_banner.dart';

void main() {
  group('ProjectInfoBanner Widget Tests', () {
    testWidgets('renders banner with message', (WidgetTester tester) async {
      // ARRANGE
      const message = 'Test Message';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProjectInfoBanner(
              message: message,
              icon: Icons.info,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('displays provided icon', (WidgetTester tester) async {
      // ARRANGE
      const testIcon = Icons.warning;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProjectInfoBanner(
              message: 'Message',
              icon: testIcon,
              color: Colors.orange,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('applies correct colors', (WidgetTester tester) async {
      // ARRANGE
      const testColor = Colors.red;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProjectInfoBanner(
              message: 'Message',
              icon: Icons.error,
              color: testColor,
            ),
          ),
        ),
      );

      // ASSERT
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      
      expect(
        decoration.color,
        AppColors.lighten(testColor, 0.95),
      );
      
      if (decoration.border is Border) {
        final border = decoration.border as Border;
        expect(
          border.top.color,
          AppColors.lighten(testColor, 0.7),
        );
      }

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, testColor);
    });

    testWidgets('handles long messages correctly', (WidgetTester tester) async {
      // ARRANGE
      const longMessage = 'This is a very long message that should wrap to multiple lines '
          'when displayed in the ProjectInfoBanner widget. It should handle this gracefully '
          'without overflowing or causing layout issues.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProjectInfoBanner(
              message: longMessage,
              icon: Icons.info,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // ASSERT - No errors should be thrown
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('applies correct text style', (WidgetTester tester) async {
      // ARRANGE
      const testColor = Colors.green;
      const message = 'Test Message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProjectInfoBanner(
              message: message,
              icon: Icons.check,
              color: testColor,
            ),
          ),
        ),
      );

      // ASSERT
      final textWidget = tester.widget<Text>(find.text(message));
      final style = textWidget.style!;
      
      expect(style.fontSize, 13);
      expect(style.color, AppColors.darken(testColor, 0.2));
    });

    testWidgets('uses correct padding and border radius', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProjectInfoBanner(
              message: 'Message',
              icon: Icons.info,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // ASSERT
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, const EdgeInsets.all(16));
      
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('maintains correct layout structure', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProjectInfoBanner(
              message: 'Message',
              icon: Icons.info,
              color: Colors.blue,
            ),
          ),
        ),
      );

  // ASSERT
  expect(find.byType(Row), findsOneWidget);
  expect(find.byType(Icon), findsOneWidget);
  expect(find.byType(SizedBox), findsWidgets); // Spacing (icon internal + explicit)
  expect(find.byType(Expanded), findsOneWidget); // For text
    });

    testWidgets('maintains accessibility features', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProjectInfoBanner(
              message: 'Test Message',
              icon: Icons.info,
              color: Colors.blue,
            ),
          ),
        ),
      );

      // ASSERT - Check for Semantics widgets
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}