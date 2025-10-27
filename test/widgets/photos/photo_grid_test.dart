// lib/test/widgets/photos/photo_grid_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

void main() {
  group('PhotoGrid Widget Tests', () {
    const mockPhotos = [
      'https://example.com/photo1.jpg',
      'https://example.com/photo2.jpg',
      'https://example.com/photo3.jpg',
    ];

    testWidgets('renders photos correctly', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: mockPhotos,
              photoSize: 100,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byType(Image), findsNWidgets(mockPhotos.length));
    });

    testWidgets('handles empty state', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: [],
              photoSize: 100,
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('shows add button when enabled', (WidgetTester tester) async {
      // ARRANGE
      var addPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: mockPhotos,
              photoSize: 100,
              canAdd: true,
              onAddPhoto: () {
                addPressed = true;
              },
            ),
          ),
        ),
      );

      // ACT
      await tester.tap(find.byIcon(Icons.add_photo_alternate_outlined));
      await tester.pumpAndSettle();

      // ASSERT
      expect(addPressed, isTrue);
    });

    testWidgets('respects max photos limit', (WidgetTester tester) async {
      // ARRANGE
      const maxPhotos = 2;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: mockPhotos,
              photoSize: 100,
              maxPhotos: maxPhotos,
              canAdd: true,
              onAddPhoto: () {},
            ),
          ),
        ),
      );

      // ASSERT
      expect(find.byIcon(Icons.add_photo_alternate_outlined), findsNothing);
    });

    testWidgets('shows remove buttons when removable', (WidgetTester tester) async {
      // ARRANGE
      var removedPhoto = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: mockPhotos,
              photoSize: 100,
              removable: true,
              onPhotoRemoved: (photo) {
                removedPhoto = photo;
              },
            ),
          ),
        ),
      );

      // ACT
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      // ASSERT
      expect(removedPhoto, equals(mockPhotos[0]));
    });

    testWidgets('handles photo selection', (WidgetTester tester) async {
      // ARRANGE
      var selectedPhoto = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: mockPhotos,
              photoSize: 100,
              selectable: true,
              onPhotoSelected: (photo) {
                selectedPhoto = photo;
              },
            ),
          ),
        ),
      );

      // ACT
      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();

      // ASSERT
      expect(selectedPhoto, equals(mockPhotos[0]));
    });

    testWidgets('shows broken image icon on error', (WidgetTester tester) async {
      // ARRANGE
      const invalidPhotos = ['invalid-url'];
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: invalidPhotos,
              photoSize: 100,
            ),
          ),
        ),
      );

      // ACT
      await tester.pumpAndSettle();

      // ASSERT
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });

    testWidgets('adapts grid layout based on photo count', (WidgetTester tester) async {
      // ARRANGE - 1 photo
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: ['photo1.jpg'],
              photoSize: 100,
            ),
          ),
        ),
      );

  // Get first layout
  var onePhotoLayout = tester.firstWidget<Wrap>(find.byType(Wrap));

      // ARRANGE - 3 photos
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: ['photo1.jpg', 'photo2.jpg', 'photo3.jpg'],
              photoSize: 100,
            ),
          ),
        ),
      );

  // Get second layout
  var threePhotosLayout = tester.firstWidget<Wrap>(find.byType(Wrap));

  // ASSERT - Layouts should be different (different number of children)
  expect(onePhotoLayout.children.length, isNot(equals(threePhotosLayout.children.length)));
    });

    testWidgets('uses fixed grid when specified', (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhotoGrid(
              photos: mockPhotos,
              photoSize: 100,
              useFixedGrid: true,
            ),
          ),
        ),
      );

      // Get layout
      final wrap = tester.firstWidget<Wrap>(find.byType(Wrap));
      
      // ASSERT - Should use fixed spacing
      expect(wrap.spacing, equals(8.0));
      expect(wrap.runSpacing, equals(8.0));
    });
  });
}