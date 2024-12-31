import 'package:flutter/material.dart';
import '../constant/app_constants.dart';

void showSnackBar(BuildContext context, String messageBody) {
  final snackBar =  SnackBar(
      duration: Duration(milliseconds: AppConstants.durationOfSnackBar),
      content: Text(messageBody));
  ScaffoldMessenger.of(context)
      .showSnackBar(snackBar);
}
