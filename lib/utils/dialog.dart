import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:flutter/material.dart';

abstract class DialogHelper {
  static Future<void> showAlertDialog<T>({
    required BuildContext context,
    String? story,
    String? btnText,
    Function? btnAction,
    String? btnText2,
    Function? btnAction2,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          story!,
          style: const TextStyle(
            color: FSColors.black,
            fontSize: 14,
          ),
        ),
        contentPadding: const EdgeInsets.all(10.0),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(FSColors.blueGrey),
            ),
            onPressed: btnAction as void Function()?,
            child: Text(
              btnText!,
              style: const TextStyle(color: FSColors.white),
            ),
          ),
          btnText2 != null
              ? TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(FSColors.blueGrey),
                  ),
                  onPressed: btnAction2 as void Function()?,
                  child: Text(
                    btnText2,
                    style: const TextStyle(color: FSColors.white),
                  ),
                )
              : const SizedBox(height: 0.0, width: 0.0)
        ],
      ),
    );
  }
}
