import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../application_form.dart';

class ApplicationFormContent extends StatefulWidget {
  final FormStepType stepType;
  final Map<String, dynamic> formData;
  final ValueChanged<Map<String, dynamic>> onDataChanged;

  const ApplicationFormContent({
    super.key,
    required this.stepType,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<ApplicationFormContent> createState() => _ApplicationFormContentState();
}

class _ApplicationFormContentState extends State<ApplicationFormContent> {
  late Map<String, dynamic> _data;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _data = Map<String, dynamic>.from(widget.formData);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildFormFields(),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    switch (widget.stepType) {
      case FormStepType.personal:
        return _buildPersonalDetailsFields();
      case FormStepType.address:
        return _buildAddressDetailsFields();
      case FormStepType.technical:
        return _buildTechnicalDetailsFields();
      case FormStepType.documents:
        return [];
      default:
        return [];
    }
  }

  List<Widget> _buildPersonalDetailsFields() {
    return [
      Text(
        'व्यक्तिगत विवरण',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 3.h),

      // Full Name
      _buildTextField(
        label: 'पूरा नाम *',
        hint: 'अपना पूरा नाम दर्ज करें',
        icon: Icons.person,
        key: 'name',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'नाम आवश्यक है';
          }
          return null;
        },
      ),

      SizedBox(height: 2.h),

      // Phone Number
      _buildTextField(
        label: 'मोबाइल नंबर *',
        hint: '10 अंकों का मोबाइल नंबर',
        icon: Icons.phone,
        key: 'phone',
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'मोबाइल नंबर आवश्यक है';
          }
          if (value.length != 10) {
            return 'मोबाइल नंबर 10 अंकों का होना चाहिए';
          }
          return null;
        },
      ),

      SizedBox(height: 2.h),

      // Email
      _buildTextField(
        label: 'ईमेल पता *',
        hint: 'example@email.com',
        icon: Icons.email,
        key: 'email',
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'ईमेल पता आवश्यक है';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'सही ईमेल पता दर्ज करें';
          }
          return null;
        },
      ),

      SizedBox(height: 2.h),

      // Aadhaar Number
      _buildTextField(
        label: 'आधार नंबर *',
        hint: 'XXXX XXXX XXXX',
        icon: Icons.credit_card,
        key: 'aadhaar',
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(12),
          _AadhaarInputFormatter(),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'आधार नंबर आवश्यक है';
          }
          if (value.replaceAll(' ', '').length != 12) {
            return 'आधार नंबर 12 अंकों का होना चाहिए';
          }
          return null;
        },
      ),

      SizedBox(height: 2.h),

      // Father's Name
      _buildTextField(
        label: 'पिता का नाम',
        hint: 'पिता का पूरा नाम',
        icon: Icons.family_restroom,
        key: 'fatherName',
      ),

      SizedBox(height: 2.h),

      // Occupation
      _buildDropdownField(
        label: 'व्यवसाय',
        hint: 'अपना व्यवसाय चुनें',
        icon: Icons.work,
        key: 'occupation',
        items: [
          'किसान',
          'व्यापारी',
          'नौकरी',
          'गृहिणी',
          'सेवानिवृत्त',
          'अन्य',
        ],
      ),
    ];
  }

  List<Widget> _buildAddressDetailsFields() {
    return [
      Text(
        'पता विवरण',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 3.h),

      // Complete Address
      _buildTextField(
        label: 'पूरा पता *',
        hint: 'घर नंबर, गली, मोहल्ला',
        icon: Icons.location_on,
        key: 'address',
        maxLines: 3,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'पता आवश्यक है';
          }
          return null;
        },
      ),

      SizedBox(height: 2.h),

      // City
      _buildTextField(
        label: 'शहर *',
        hint: 'शहर का नाम',
        icon: Icons.location_city,
        key: 'city',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'शहर का नाम आवश्यक है';
          }
          return null;
        },
      ),

      SizedBox(height: 2.h),

      // State
      _buildDropdownField(
        label: 'राज्य *',
        hint: 'राज्य चुनें',
        icon: Icons.map,
        key: 'state',
        items: [
          'राजस्थान',
          'गुजरात',
          'महाराष्ट्र',
          'उत्तर प्रदेश',
          'मध्य प्रदेश',
          'हरियाणा',
          'पंजाब',
          'अन्य',
        ],
        isRequired: true,
      ),

      SizedBox(height: 2.h),

      // Pincode
      _buildTextField(
        label: 'पिन कोड *',
        hint: '6 अंकों का पिन कोड',
        icon: Icons.pin_drop,
        key: 'pincode',
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'पिन कोड आवश्यक है';
          }
          if (value.length != 6) {
            return 'पिन कोड 6 अंकों का होना चाहिए';
          }
          return null;
        },
      ),

      SizedBox(height: 2.h),

      // District
      _buildTextField(
        label: 'जिला',
        hint: 'जिले का नाम',
        icon: Icons.account_balance,
        key: 'district',
      ),
    ];
  }

  List<Widget> _buildTechnicalDetailsFields() {
    return [
      Text(
        'तकनीकी विवरण',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 3.h),

      // Roof Area
      _buildTextField(
        label: 'छत का क्षेत्रफल (वर्ग फुट) *',
        hint: 'छत का कुल क्षेत्रफल',
        icon: Icons.roofing,
        key: 'roofArea',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'छत का क्षेत्रफल आवश्यक है';
          }
          return null;
        },
      ),

      SizedBox(height: 2.h),

      // Roof Type
      _buildDropdownField(
        label: 'छत का प्रकार',
        hint: 'छत का प्रकार चुनें',
        icon: Icons.home,
        key: 'roofType',
        items: [
          'RCC (कंक्रीट)',
          'टिन शेड',
          'टाइल्स',
          'अन्य',
        ],
      ),

      SizedBox(height: 2.h),

      // Electricity Connection
      _buildDropdownField(
        label: 'बिजली कनेक्शन *',
        hint: 'बिजली कनेक्शन है?',
        icon: Icons.electrical_services,
        key: 'electricityConnection',
        items: [
          'हां',
          'नहीं',
        ],
        isRequired: true,
      ),

      SizedBox(height: 2.h),

      // Monthly Bill
      _buildTextField(
        label: 'मासिक बिजली बिल (रुपए)',
        hint: 'औसत मासिक बिल',
        icon: Icons.receipt,
        key: 'monthlyBill',
        keyboardType: TextInputType.number,
      ),

      SizedBox(height: 2.h),

      // Solar Capacity Required
      _buildDropdownField(
        label: 'आवश्यक सोलर क्षमता (kW)',
        hint: 'सोलर क्षमता चुनें',
        icon: Icons.solar_power,
        key: 'solarCapacity',
        items: [
          '1 kW',
          '2 kW',
          '3 kW',
          '5 kW',
          '10 kW',
          'अन्य',
        ],
      ),

      SizedBox(height: 2.h),

      // Roof Direction
      _buildDropdownField(
        label: 'छत की दिशा',
        hint: 'छत की मुख्य दिशा',
        icon: Icons.explore,
        key: 'roofDirection',
        items: [
          'दक्षिण',
          'दक्षिण-पूर्व',
          'दक्षिण-पश्चिम',
          'पूर्व',
          'पश्चिम',
          'उत्तर',
        ],
      ),
    ];
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required String key,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          initialValue: _data[key]?.toString() ?? '',
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          onChanged: (value) {
            setState(() {
              _data[key] = value;
            });
            widget.onDataChanged(_data);
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String key,
    required List<String> items,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _data[key],
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          validator: isRequired ? (value) {
            if (value == null || value.isEmpty) {
              return '$label आवश्यक है';
            }
            return null;
          } : null,
          onChanged: (String? value) {
            setState(() {
              _data[key] = value;
            });
            widget.onDataChanged(_data);
          },
        ),
      ],
    );
  }
}

// Custom formatter for Aadhaar number
class _AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}