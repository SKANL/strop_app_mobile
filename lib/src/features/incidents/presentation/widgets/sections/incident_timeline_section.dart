// lib/src/features/incidents/presentation/widgets/sections/incident_timeline_section.dart
import 'package:flutter/material.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget that displays the chronological timeline of incident events
class IncidentTimelineSection extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;

  const IncidentTimelineSection({
    super.key,
    required this.timeline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline cronológico',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...timeline.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          
          return TimelineEvent(
            title: '${event['actor']} ${event['description']}',
            timestamp: event['timestamp'] as DateTime,
            icon: _getIconForType(event['type']),
            iconColor: _getColorForType(event['type']),
            isFirst: index == 0,
            isLast: index == timeline.length - 1,
          );
        }),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'created':
        return Icons.add_circle_outline;
      case 'assigned':
        return Icons.person_add;
      case 'comment':
        return Icons.comment;
      case 'correction':
        return Icons.edit_note;
      case 'closed':
        return Icons.check_circle;
      case 'approved':
        return Icons.thumb_up;
      case 'rejected':
        return Icons.thumb_down;
      default:
        return Icons.circle;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'created':
        return AppColors.openStatusColor;
      case 'assigned':
        return AppColors.assignedColor;
      case 'comment':
        return AppColors.iconColor;
      case 'correction':
        return AppColors.problemColor;
      case 'closed':
        return AppColors.closedStatusColor;
      case 'approved':
        return AppColors.approvedColor;
      case 'rejected':
        return AppColors.rejectedColor;
      default:
        return AppColors.iconColor;
    }
  }
}
