import 'package:flutter/material.dart';

enum SnackBarType {
  Error,
  Information,
  Success,
}

void showSnackBar(BuildContext context, SnackBarType snackBarType, String message) {

  Color snackBarColor;

  switch (snackBarType) {
    case SnackBarType.Error:
      snackBarColor = Colors.red;
      break;
    case SnackBarType.Information:
      snackBarColor = Colors.blue;
      break;
    case SnackBarType.Success:
      snackBarColor = Colors.green;
      break;
  }

  final snackBar = SnackBar(
    content: SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        child: Text(message),
      ),
    ),
    backgroundColor: snackBarColor,
    behavior: SnackBarBehavior.floating,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
