import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './extensions/string_extension.dart';

void toastMessage(String message, int statusCode) {
  statusCode == 200 ? toastSuccess(message) : toastError(message);
}

void toastError(String message) {
  Fluttertoast.showToast(
    msg: "$message".capitalize(),
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

void toastSuccess(String message) {
  Fluttertoast.showToast(
    msg: "$message".capitalize(),
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color(0xFF266ED1),
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
