library keyboard_richtext;

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rich_text_composer/rich_text_controller.dart';

class KeyboardRichText extends StatelessWidget {
  const KeyboardRichText({
    Key? key,
    required this.child,
    required this.richTextController,
    required this.keyBroadToolbar,
  }) : super(key: key);

  final Widget child;
  final Widget keyBroadToolbar;
  final RichTextController richTextController;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SizedBox(
        height: double.infinity,
        child: child),
      KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        if (isKeyboardVisible) {
          return ValueListenableBuilder(
            valueListenable: richTextController.richTextToolbarNotifier,
            builder: (_, value, child) {
              if (value) {
                return PositionedDirectional(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  start: 0,
                  end: 0,
                  child: keyBroadToolbar,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      })
    ]);
  }
}
