import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class DocumentUploadSection extends StatefulWidget {
  final Map<String, dynamic> formData;
  final ValueChanged<Map<String, dynamic>> onDataChanged;

  const DocumentUploadSection({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<DocumentUploadSection> createState() => _DocumentUploadSectionState();
}

class _DocumentUploadSectionState extends State<DocumentUploadSection> {
  late Map<String, dynamic> _documents;

  final List<Map<String, dynamic>> _requiredDocuments = [
    {
      'id': 'aadhaar',
      'title': 'आधार कार्ड',
      'description': 'आधार कार्ड की स्पष्ट फोटो',
      'icon': Icons.credit_card,
      'uploaded': false,
    },
    {
      'id': 'electricity_bill',
      'title': 'बिजली बिल',
      'description': 'पिछले 3 महीने का बिजली बिल',
      'icon': Icons.receipt_long,
      'uploaded': false,
    },
    {
      'id': 'property_documents',
      'title': 'घर के कागजात',
      'description': 'मकान के स्वामित्व के कागजात',
      'icon': Icons.home_work,
      'uploaded': false,
    },
    {
      'id': 'bank_statement',
      'title': 'बैंक स्टेटमेंट',
      'description': 'पिछले 6 महीने का बैंक स्टेटमेंट',
      'icon': Icons.account_balance,
      'uploaded': false,
    },
    {
      'id': 'income_certificate',
      'title': 'आय प्रमाण पत्र',
      'description': 'वैध आय प्रमाण पत्र',
      'icon': Icons.assignment,
      'uploaded': false,
    },
    {
      'id': 'roof_photo',
      'title': 'छत की फोटो',
      'description': 'छत की स्पष्ट फोटो (4 दिशाओं से)',
      'icon': Icons.photo_camera,
      'uploaded': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _documents = Map<String, dynamic>.from(widget.formData);
    
    // Initialize document status from existing data
    for (var doc in _requiredDocuments) {
      doc['uploaded'] = _documents[doc['id']] != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'आवश्यक दस्तावेज़',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'सभी दस्तावेज़ अपलोड करना आवश्यक है',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 3.h),

          // Upload progress
          _buildUploadProgress(),
          SizedBox(height: 3.h),

          // Document list
          ...List.generate(
            _requiredDocuments.length,
            (index) => _buildDocumentCard(_requiredDocuments[index]),
          ),

          SizedBox(height: 3.h),

          // Important notes
          _buildImportantNotes(),
        ],
      ),
    );
  }

  Widget _buildUploadProgress() {
    final uploadedCount = _requiredDocuments.where((doc) => doc['uploaded'] as bool).length;
    final progress = uploadedCount / _requiredDocuments.length;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'अपलोड प्रगति',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
              Text(
                '$uploadedCount/${_requiredDocuments.length}',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.blue.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> document) {
    final isUploaded = document['uploaded'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: isUploaded ? Colors.green.shade300 : Colors.grey.shade300,
          width: isUploaded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            // Document icon
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isUploaded
                    ? Colors.green.shade100
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Icon(
                document['icon'] as IconData,
                color: isUploaded
                    ? Colors.green.shade600
                    : Colors.grey.shade600,
                size: 6.w,
              ),
            ),

            SizedBox(width: 4.w),

            // Document info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document['title'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    document['description'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (isUploaded) ...[
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'अपलोड हो गया',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Upload button
            ElevatedButton.icon(
              onPressed: () => _uploadDocument(document),
              icon: Icon(
                isUploaded ? Icons.edit : Icons.upload,
                size: 4.w,
              ),
              label: Text(isUploaded ? 'बदलें' : 'अपलोड'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isUploaded
                    ? Colors.orange.shade500
                    : Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportantNotes() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info,
                color: Colors.amber.shade700,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'महत्वपूर्ण सूचना',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '• सभी दस्तावेज़ स्पष्ट और पढ़ने योग्य होने चाहिए\n'
            '• फाइल का आकार 5MB से कम होना चाहिए\n'
            '• केवल JPG, PNG, PDF फॉर्मेट स्वीकार्य हैं\n'
            '• सभी दस्तावेज़ वैध और अद्यतन होने चाहिए',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }

  void _uploadDocument(Map<String, dynamic> document) {
    // Simulate document upload
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('दस्तावेज़ अपलोड करें'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${document['title']} अपलोड करने के लिए विकल्प चुनें:'),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _simulateUpload(document, 'camera');
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('कैमरा'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _simulateUpload(document, 'gallery');
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text('गैलरी'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('रद्द करें'),
          ),
        ],
      ),
    );
  }

  void _simulateUpload(Map<String, dynamic> document, String source) {
    // Show upload progress
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 2.h),
            Text('अपलोड हो रहा है...'),
          ],
        ),
      ),
    );

    // Simulate upload delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close progress dialog

      setState(() {
        document['uploaded'] = true;
        _documents[document['id']] = {
          'source': source,
          'uploadedAt': DateTime.now().toIso8601String(),
          'fileName': '${document['id']}_${DateTime.now().millisecondsSinceEpoch}',
        };
      });

      widget.onDataChanged(_documents);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${document['title']} सफलतापूर्वक अपलोड हो गया'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}