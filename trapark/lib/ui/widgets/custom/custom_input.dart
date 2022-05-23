// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:otopark/constants/size_config.dart';
import 'package:otopark/constants/theme/color.dart';
import 'package:get/get.dart';

class CustomInput extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  FocusNode? focusNode;
  var onChanged;

  CustomInput(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.focusNode,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.075,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged!,
        decoration: InputDecoration(
          fillColor: lightGrayColor,
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
