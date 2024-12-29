import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(
      {required BuildContext context, required String message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static void showMessage({
    required BuildContext context,
    required String content,
    String title = '',
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    List<Widget> actions = [];

    if (posActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog

            if (posAction != null) {
              posAction(); // Call the provided positive action
            }
          },
          child: Text(posActionName),
        ),
      );
    }

    if (negActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Close the dialog
            }
            if (negAction != null) {
              negAction(); // Call the provided negative action
            }
          },
          child: Text(negActionName),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: title.isNotEmpty
              ? Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                )
              : null,
          content: Text(content),
          actions: actions,
        );
      },
    );
  }
}
