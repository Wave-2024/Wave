import 'package:flutter/material.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool visible;
  final Icon prefixIcon;
  final suffixIcon;
  int? maxLength;
  String? uniqueKey;
  bool? readOnly;

  String? Function(String?)? validator;

  AuthTextField(
      {required this.controller,
      required this.label,
      required this.visible,
      this.readOnly,
      required this.prefixIcon,
      this.suffixIcon,
      this.maxLength,
      this.uniqueKey,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(uniqueKey!),
      readOnly: readOnly ?? false,
      controller: controller,
      validator: validator,
      maxLength: maxLength,
      obscureText: !visible,
      cursorColor: Colors.black87,
      style: TextStyle(color: Colors.black, fontFamily: CustomFont.poppins),
      decoration: InputDecoration(
        counterStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: CustomColor.authTextBoxColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle:
            TextStyle(color: Colors.black, fontFamily: CustomFont.poppins),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColor.authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColor.authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColor.authTextBoxBorderColor),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
