import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key, required this.controller, required this.hintText})
      : super(key: key);
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black38,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter your$hintText';
        }
        return null;
      },
    );
  }
}
