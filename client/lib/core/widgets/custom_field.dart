import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isobscureText = false,
    this.readOnly = false,
    this.onTap,
  });
  final TextEditingController? controller;
  final String hintText;
  final bool isobscureText;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      obscureText: isobscureText,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
    );
  }
}
