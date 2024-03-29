import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static snackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 10)));
  }

  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_LONG, timeInSecForIosWeb: 5);
  }

  static flushBarErrorMsg(
    String msg,
    BuildContext context,
  ) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          borderRadius: BorderRadius.circular(20),
          forwardAnimationCurve: Curves.bounceIn,
          reverseAnimationCurve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          positionOffset: 20,
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(
            Icons.error,
            color: Colors.white,
            size: 28,
          ),
          title: "Error",
          message: msg,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        )..show(context));
  }
}
