import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AnnotationToolsWidget extends StatelessWidget {
  final Map<String, dynamic> annotation;
  final VoidCallback onRemove;

  const AnnotationToolsWidget({
    super.key,
    required this.annotation,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final position = annotation['position'] as Map<String, dynamic>;
    final x = (position['x'] as num).toDouble();
    final y = (position['y'] as num).toDouble();

    return Positioned(
      left: x - 16,
      top: y - 16,
      child: GestureDetector(
        onTap: () => _showAnnotationDialog(context),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _getAnnotationColor(annotation['type']),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            _getAnnotationIcon(annotation['type']),
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }

  Color _getAnnotationColor(String type) {
    switch (type) {
      case 'obstacle':
        return AppTheme.errorLight;
      case 'shade':
        return Colors.orange;
      case 'water_tank':
        return Colors.blue;
      case 'chimney':
        return Colors.brown;
      case 'note':
        return AppTheme.accentLight;
      default:
        return AppTheme.primaryLight;
    }
  }

  IconData _getAnnotationIcon(String type) {
    switch (type) {
      case 'obstacle':
        return Icons.block;
      case 'shade':
        return Icons.wb_shade;
      case 'water_tank':
        return Icons.water_drop;
      case 'chimney':
        return Icons.fireplace;
      case 'note':
        return Icons.note;
      default:
        return Icons.place;
    }
  }

  void _showAnnotationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getAnnotationIcon(annotation['type']),
              color: _getAnnotationColor(annotation['type']),
            ),
            const SizedBox(width: 8),
            Text(
              _formatAnnotationType(annotation['type']),
              style: GoogleFonts.poppins(fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              annotation['description'] ?? 'No description',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Added: ${_formatTimestamp(annotation['timestamp'])}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRemove();
            },
            child: Text(
              'Remove',
              style: GoogleFonts.inter(
                color: AppTheme.errorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAnnotationType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }
}

class AnnotationToolsPanel extends StatelessWidget {
  final Function(String, String, Offset) onAddAnnotation;
  final Offset position;

  const AnnotationToolsPanel({
    super.key,
    required this.onAddAnnotation,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Annotation',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildAnnotationButton(
                context,
                'obstacle',
                'Obstacle',
                Icons.block,
                AppTheme.errorLight,
              ),
              _buildAnnotationButton(
                context,
                'shade',
                'Shade',
                Icons.wb_shade,
                Colors.orange,
              ),
              _buildAnnotationButton(
                context,
                'water_tank',
                'Water Tank',
                Icons.water_drop,
                Colors.blue,
              ),
              _buildAnnotationButton(
                context,
                'chimney',
                'Chimney',
                Icons.fireplace,
                Colors.brown,
              ),
              _buildAnnotationButton(
                context,
                'note',
                'Note',
                Icons.note,
                AppTheme.accentLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnnotationButton(
    BuildContext context,
    String type,
    String label,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => _showAddAnnotationDialog(context, type, label, icon, color),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAnnotationDialog(
    BuildContext context,
    String type,
    String label,
    IconData icon,
    Color color,
  ) {
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.poppins()),
          ],
        ),
        content: TextField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'Add details about this annotation...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Close tools panel
              onAddAnnotation(
                type,
                descriptionController.text.isNotEmpty
                    ? descriptionController.text
                    : 'No description',
                position,
              );
            },
            child: Text('Add', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }
}