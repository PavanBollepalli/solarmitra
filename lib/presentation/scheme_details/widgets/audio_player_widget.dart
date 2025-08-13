import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String text;
  final String language;

  const AudioPlayerWidget({
    super.key,
    required this.text,
    this.language = 'hi',
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: _togglePlayback,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: _isPlaying
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isPlaying
                      ? theme.colorScheme.primary
                      : theme.dividerColor,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _isPlaying ? 'pause' : 'play_arrow',
                    color: _isPlaying
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 1.w),
                  if (_isPlaying) ...[
                    _buildSoundWave(theme),
                    SizedBox(width: 2.w),
                    Text(
                      'Playing...',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else
                    Text(
                      'Listen',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSoundWave(ThemeData theme) {
    return Row(
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
          width: 2,
          height: _isPlaying ? (8 + (index * 2)).toDouble() : 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _startTextToSpeech();
    } else {
      _stopTextToSpeech();
    }
  }

  void _startTextToSpeech() {
    // Simulate text-to-speech playback
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing audio in ${_getLanguageName(widget.language)}'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _stopTextToSpeech() {
    // Stop text-to-speech playback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Audio playback stopped'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'Hindi';
      case 'te':
        return 'Telugu';
      case 'ta':
        return 'Tamil';
      case 'kn':
        return 'Kannada';
      case 'mr':
        return 'Marathi';
      case 'bn':
        return 'Bengali';
      default:
        return 'English';
    }
  }
}
