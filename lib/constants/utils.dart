import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSnackBar({required String text}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   content: Text(text),
  //   duration: const Duration(seconds: 2),
  // ));
}
