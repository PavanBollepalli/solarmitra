import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PhotoGalleryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> photos;
  final Function(Map<String, dynamic>) onPhotoTap;

  const PhotoGalleryWidget({
    super.key,
    required this.photos,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();

    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(179),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryLight.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.photo_library,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '${photos.length}',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Photo thumbnails
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return GestureDetector(
                  onTap: () => onPhotoTap(photo),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.accentLight.withAlpha(128),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Stack(
                        children: [
                          // Photo thumbnail
                          Image.file(
                            File(photo['path']),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              );
                            },
                          ),

                          // Photo index
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // GPS indicator
                          if (photo['location'] != null)
                            const Positioned(
                              bottom: 2,
                              left: 2,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 10,
                              ),
                            ),

                          // Measurement indicator
                          if (photo['measurements'] != null &&
                              (photo['measurements'] as List).isNotEmpty)
                            const Positioned(
                              bottom: 2,
                              right: 2,
                              child: Icon(
                                Icons.straighten,
                                color: AppTheme.accentLight,
                                size: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}