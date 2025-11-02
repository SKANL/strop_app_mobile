// lib/test/widgets/banners/project_info_banner_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

void main() {
  group('InfoBanner Widget Tests (formerly ProjectInfoBanner)', () {
    testWidgets('renders banner with message', (WidgetTester tester) async {
      // ARRANGE
      const message = 'Test Message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: message,
              icon: Icons.info,
              type: InfoBannerType.info,
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
            body: InfoBanner(
              message: 'Message',
              icon: testIcon,
              type: InfoBannerType.warning,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('displays info type banner correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Info message',
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text('Info message'), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('handles long messages correctly', (WidgetTester tester) async {
      // ARRANGE
      const longMessage = 'This is a very long message that should wrap to multiple lines '
          'when displayed in the InfoBanner widget. It should handle this gracefully '
          'without overflowing or causing layout issues.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: longMessage,
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT - No errors should be thrown
      expect(find.text(longMessage), findsOneWidget);
    });

    testWidgets('warning type displays correctly', (WidgetTester tester) async {
      // ARRANGE
      const message = 'Warning Message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: message,
              type: InfoBannerType.warning,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text(message), findsOneWidget);
    });

    testWidgets('maintains correct layout structure', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              message: 'Message',
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('supports optional title', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoBanner(
              title: 'Important',
              message: 'Test Message',
              type: InfoBannerType.info,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.text('Important'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });
  });
}