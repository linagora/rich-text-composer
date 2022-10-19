
import 'package:flutter/material.dart';

class DialogUtils {

  static void showDialogBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)),
      ),
      barrierColor: Colors.black38,
      backgroundColor: Colors.white,
      constraints: const BoxConstraints(maxWidth: 716),
      builder: (_) {
        return LayoutBuilder(
            builder: (context, _) {
              return AnimatedPadding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: child
              );
            }
        );
      }
    );
  }

  static void showDialogCenter(
      BuildContext context,
      {required Widget Function(BuildContext context) builder}
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          content: SizedBox(
            width: 448,
            height: 436,
            child: builder.call(context),
          ),
        );
      },
    );
  }
}