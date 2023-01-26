import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static Future<void> showMessage(
    BuildContext context, {
    required String errorMessage,
  }) async {
    await Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
