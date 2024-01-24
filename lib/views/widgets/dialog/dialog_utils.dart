
import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils? _instance;

  DialogUtils._();

  factory DialogUtils() => _instance ??= DialogUtils._();

  Future showDialogBottomSheet(BuildContext context, Widget child) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16))),
      barrierColor: Colors.black38,
      backgroundColor: Colors.white,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 600),
      builder: (_) {
        return AnimatedPadding(
          padding: EdgeInsets.zero,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: child);
      }
    );
  }

  Future showDialogCenter(
      BuildContext context,
      {required Widget Function(BuildContext context) builder}
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.zero,
          scrollable: true,
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