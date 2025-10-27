// lib/test/widgets/banners/banner_info_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

void main() {
  group('BannerInfo Widget Tests', () {
    testWidgets('renders banner with message', (WidgetTester tester) async {
      // ARRANGE
      const message = 'Test Message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo(
              message: message,
              type: BannerType.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('displays correct icon for info type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo(
              message: 'Message',
              type: BannerType.info,
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
            body: BannerInfo(
              message: 'Message',
              type: BannerType.warning,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('displays correct icon for success type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo.success(
              message: 'Message',
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('displays correct icon for error type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo.error(
              message: 'Message',
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('applies correct colors based on type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo.error(
              message: 'Message',
            ),
          ),
        ),
      );

      // ASSERT - Check for red colors
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFFFEBEE)); // Error background color
      
      if (decoration.border is Border) {
        final border = decoration.border as Border;
        expect(border.top.color, const Color(0xFFF44336)); // Error border color
      }
    });

    testWidgets('handles onDismiss callback when dismissible', (WidgetTester tester) async {
      // ARRANGE
      var dismissed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BannerInfo(
              message: 'Message',
              type: BannerType.info,
              isDismissible: true,
              onDismiss: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      // ACT
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // ASSERT
      expect(dismissed, isTrue);
    });

    testWidgets('does not show close button when not dismissible', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo(
              message: 'Message',
              type: BannerType.info,
              isDismissible: false,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('shows custom icon when provided', (WidgetTester tester) async {
      // ARRANGE
      const customIcon = Icons.star;
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo(
              message: 'Message',
              type: BannerType.info,
              customIcon: customIcon,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(customIcon), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });

    testWidgets('displays action buttons when provided', (WidgetTester tester) async {
      // ARRANGE
      var buttonPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BannerInfo(
              message: 'Message',
              type: BannerType.info,
              actions: [
                TextButton(
                  onPressed: () {
                    buttonPressed = true;
                  },
                  child: const Text('Action'),
                ),
              ],
            ),
          ),
        ),
      );

      // ACT
      await tester.tap(find.text('Action'));
      await tester.pumpAndSettle();

      // ASSERT
      expect(find.byType(TextButton), findsOneWidget);
      expect(buttonPressed, isTrue);
    });

    testWidgets('handles long messages correctly', (WidgetTester tester) async {
      // ARRANGE
      const longMessage = 'This is a very long message that should wrap to multiple lines '
          'when displayed in the BannerInfo widget. It should handle this gracefully '
          'without overflowing or causing layout issues.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo(
              message: longMessage,
              type: BannerType.info,
            ),
          ),
        ),
      );

      // ASSERT - No errors should be thrown
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('maintains accessibility features', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BannerInfo(
              message: 'Test Message',
              type: BannerType.info,
            ),
          ),
        ),
      );

      // ASSERT - Check for Semantics widgets
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}