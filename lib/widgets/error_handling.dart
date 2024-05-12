import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ErrorHandler {
  static void showError(BuildContext context, String errorMessage) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: const Text('Error!'),
      description: Text(errorMessage),
      alignment: Alignment.bottomCenter,
      animationDuration: const Duration(milliseconds: 400),
      borderRadius: BorderRadius.circular(12.0),
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: true,
      dragToClose: true,
    );
  }
}
