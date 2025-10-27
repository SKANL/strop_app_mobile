// lib/test/widgets/banners/critical_banner_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';

void main() {
  group('CriticalBanner Widget Tests', () {
    testWidgets('renders banner with message', (WidgetTester tester) async {
      // ARRANGE
      const message = 'Test Message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: message,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('displays warning icon by default', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: 'Message',
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('displays error icon for error type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: 'Message',
              type: CriticalBannerType.error,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('displays info icon for info type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: 'Message',
              type: CriticalBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
    });

    testWidgets('applies correct colors for warning type', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: 'Message',
              type: CriticalBannerType.warning,
            ),
          ),
        ),
      );

      // ASSERT
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      final color = AppColors.warning;
      
      expect(
        decoration.color,
        AppColors.lighten(color, 0.85),
      );
      
      if (decoration.border is Border) {
        final border = decoration.border as Border;
        expect(border.top.color, color);
      }
    });

    testWidgets('can hide icon when showIcon is false', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: 'Message',
              showIcon: false,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('handles long messages correctly', (WidgetTester tester) async {
      // ARRANGE
      const longMessage = 'This is a very long message that should wrap to multiple lines '
          'when displayed in the CriticalBanner widget. It should handle this gracefully '
          'without overflowing or causing layout issues.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: longMessage,
            ),
          ),
        ),
      );

      // ASSERT - No errors should be thrown
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('maintains correct text style', (WidgetTester tester) async {
      // ARRANGE
      const message = 'Test Message';
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: message,
              type: CriticalBannerType.warning,
            ),
          ),
        ),
      );

      // ASSERT
      final textWidget = tester.widget<Text>(find.text(message));
      final style = textWidget.style!;
      
      // Check font properties
      expect(style.fontSize, 14);
      expect(style.fontWeight, FontWeight.w500);
      
      // Color should be a darker shade of the warning color
      final expectedColor = AppColors.darken(AppColors.warning, 0.2);
      expect(style.color, expectedColor);
    });

    testWidgets('uses correct padding and border radius', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: 'Message',
            ),
          ),
        ),
      );

      // ASSERT
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, const EdgeInsets.all(12));
      
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets('maintains accessibility features', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CriticalBanner(
              message: 'Test Message',
            ),
          ),
        ),
      );

      // ASSERT - Check for Semantics widgets
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}