import 'package:flutter/material.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/device_size.dart';

class TextBoxForEditProfile extends StatelessWidget {
  TextBoxForEditProfile(
      {super.key,
      required this.label,
      required this.controller,
      required this.visible,
      this.prefixIcon,
      this.maxLines,
      this.suffixIcon,
      this.maxLength,
      this.uniqueKey,
      this.readOnly,
      this.onChanged,
      this.validator});

  final String label;
  final TextEditingController controller;
  final bool visible;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  int? maxLength;
  int? maxLines;
  String? uniqueKey;
  bool? readOnly;
  Function(String)? onChanged;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines == null ? displayHeight(context) * 0.11 : null,
      child: TextFormField(
        onChanged: onChanged,
        maxLines: maxLines,
        minLines: 1,
        key: uniqueKey != null ? Key(uniqueKey!) : null,
        readOnly: readOnly ?? false,
        controller: controller,
        validator: validator,
        maxLength: maxLength,
        obscureText: !visible,
        cursorColor: Colors.black87,
        style: TextStyle(
            color: Colors.black, fontFamily: CustomFont.poppins, fontSize: 13),
        decoration: InputDecoration(
          counterStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.black,
              fontFamily: CustomFont.poppins,
              fontSize: 13.5),
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
      ),
    );
  }
}
