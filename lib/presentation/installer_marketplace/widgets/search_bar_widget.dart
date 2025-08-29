import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterPressed;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'इंस्टॉलर या स्थान खोजें...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.grey.shade500,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                  size: 5.w,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey.shade500,
                          size: 5.w,
                        ),
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        
        SizedBox(width: 3.w),
        
        // Filter button
        Container(
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: IconButton(
            onPressed: onFilterPressed,
            icon: Icon(
              Icons.tune,
              color: Colors.white,
              size: 5.w,
            ),
          ),
        ),
      ],
    );
  }
}