import 'package:flutter/material.dart';

/// Simple skeleton placeholder para listas.
class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final double height;

  const ListSkeleton({super.key, this.itemCount = 6, this.height = 72});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Container(width: 56, height: height - 24, color: Colors.grey.shade300),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 150, color: Colors.grey.shade300),
                ],
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: itemCount,
    );
  }
}
