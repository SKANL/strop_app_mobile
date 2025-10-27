// lib/test/widgets/banners/info_banner_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

void main() {
  group('InfoBanner Widget Tests', () {
    testWidgets('renders banner with title and message', (WidgetTester tester) async {
      // ARRANGE
      const title = 'Test Title';
      const message = 'Test Message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: title,
              message: message,
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(title), findsOneWidget);
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('displays correct icon for info type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Info',
              message: 'Message',
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('displays correct icon for warning type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Warning',
              message: 'Message',
              type: InfoBannerType.warning,
            ),
          ),
        ),
      );

  // ASSERT
  expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    });

    testWidgets('displays correct icon for error type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Error',
              message: 'Message',
              type: InfoBannerType.error,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('displays correct icon for success type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Success',
              message: 'Message',
              type: InfoBannerType.success,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('applies correct color based on type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Test',
              message: 'Message',
              type: InfoBannerType.error,
            ),
          ),
        ),
      );

      // ASSERT - Check for red color presence
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.red[50]);
    });

    testWidgets('handles onClose callback', (WidgetTester tester) async {
      // ARRANGE
      var closed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Test',
              message: 'Message',
              type: InfoBannerType.info,
              onClose: () {
                closed = true;
              },
            ),
          ),
        ),
      );

      // ACT
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // ASSERT
      expect(closed, isTrue);
    });

    testWidgets('does not show close button when onClose is null', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Test',
              message: 'Message',
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('handles long text correctly', (WidgetTester tester) async {
      // ARRANGE
      const longMessage = 'This is a very long message that should wrap to multiple lines '
          'when displayed in the InfoBanner widget. It should handle this gracefully '
          'without overflowing or causing layout issues.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Long Text Test',
              message: longMessage,
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT - No errors should be thrown
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('applies custom style when provided', (WidgetTester tester) async {
      // ARRANGE
      const customTextStyle = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Styled Test',
              message: 'Test Message',
              type: InfoBannerType.info,
              titleStyle: customTextStyle,
            ),
          ),
        ),
      );

      // ASSERT
      final titleWidget = tester.widget<Text>(find.text('Styled Test'));
      expect(titleWidget.style?.fontSize, equals(customTextStyle.fontSize));
      expect(titleWidget.style?.fontWeight, equals(customTextStyle.fontWeight));
    });

    testWidgets('maintains accessibility features', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Accessibility Test',
              message: 'Test Message',
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT - Check for Semantics widgets
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}