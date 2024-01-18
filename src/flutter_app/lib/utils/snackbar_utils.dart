import 'package:flutter/material.dart';

enum SnackBarType {
  Error,
  Information,
  Success,
}

void showSnackBar(BuildContext context, SnackBarType snackBarType, String message) {
  double screenWidth = MediaQuery.of(context).size.width;
  double snackBarWidth = screenWidth * 0.5;

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
        width: snackBarWidth,
        alignment: Alignment.topCenter,
        child: Text(message),
      ),
    ),
    backgroundColor: snackBarColor,
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 50,
      left: (screenWidth - snackBarWidth) / 2,
      right: (screenWidth - snackBarWidth) / 2,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
