import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class InstallerCard extends StatelessWidget {
  final Map<String, dynamic> installer;
  final VoidCallback onTap;
  final VoidCallback onContact;
  final VoidCallback onGetQuote;

  const InstallerCard({
    super.key,
    required this.installer,
    required this.onTap,
    required this.onContact,
    required this.onGetQuote,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isVerified = installer['isVerified'] as bool;
    final availability = installer['availability'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withOpacity(0.1),
                  theme.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(4.w),
              ),
            ),
            child: Row(
              children: [
                // Profile image placeholder
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3.w),
                  ),
                  child: Icon(
                    Icons.business,
                    color: theme.primaryColor,
                    size: 7.w,
                  ),
                ),

                SizedBox(width: 3.w),

                // Company info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              installer['name'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (isVerified)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.green.shade600,
                                    size: 3.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'सत्यापित',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 0.5.h),

                      Text(
                        'Owner: ${installer['ownerName']}',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Rating and reviews
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${installer['rating']}',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '(${installer['reviewCount']} समीक्षाएं)',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Availability status
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: availability == 'उपलब्ध'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    availability,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: availability == 'उपलब्ध'
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details section
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Key info row
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.work_history,
                      installer['experience'] as String,
                      'अनुभव',
                    ),
                    SizedBox(width: 3.w),
                    _buildInfoChip(
                      Icons.location_on,
                      installer['distance'] as String,
                      'दूरी',
                    ),
                    SizedBox(width: 3.w),
                    _buildInfoChip(
                      Icons.construction,
                      '${installer['projectsCompleted']}',
                      'प्रोजेक्ट्स',
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Specialization
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: Colors.grey.shade600,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'विशेषज्ञता: ',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        (installer['specialization'] as List).join(', '),
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Price range
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      color: Colors.grey.shade600,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'मूल्य सीमा: ',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      '₹${_formatPrice(installer['minPrice'] as int)} - ₹${_formatPrice(installer['maxPrice'] as int)}',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Response time
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey.shade600,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'प्रतिक्रिया समय: ',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      installer['responseTime'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Certifications
                if ((installer['certifications'] as List).isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: (installer['certifications'] as List<String>)
                          .map((cert) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(1.w),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  cert,
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onContact,
                        icon: Icon(Icons.phone, size: 4.w),
                        label: Text('संपर्क करें'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.primaryColor,
                          side: BorderSide(color: theme.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onGetQuote,
                        icon: Icon(Icons.request_quote, size: 4.w),
                        label: Text('कोटेशन लें'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // View details button
                TextButton(
                  onPressed: onTap,
                  child: Text('पूरा विवरण देखें'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.grey.shade600,
              size: 4.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(1)}L';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    } else {
      return price.toString();
    }
  }
}