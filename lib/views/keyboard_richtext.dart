library keyboard_richtext;

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rich_text_composer/keybroad_richtext_controller.dart';

class KeyboardRichText extends StatelessWidget {
  const KeyboardRichText({
    Key? key,
    required this.child,
    required this.backgroundKeyboardToolBarColor,
    required this.keyBroadToolbar,
    this.heightToolBar = 48,
    this.richTextController,
  }) : super(key: key);

  final Widget child;
  final Widget keyBroadToolbar;
  final KeyboardRichTextController? richTextController;
  final Color backgroundKeyboardToolBarColor;
  final double? heightToolBar;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        body: child,
        bottomSheet: StreamBuilder(
          stream: richTextController?.richTextStream ?? KeyboardRichTextController().richTextStream,
          builder: (context, snapshot) {
            return Visibility(
              visible: snapshot.hasData &&
                  snapshot.data == true &&
                  isKeyboardVisible,
              child: Container(
                height: heightToolBar,
                color: backgroundKeyboardToolBarColor,
                alignment: Alignment.centerLeft,
                child: keyBroadToolbar,
              ),
            );
          },
        ),
      );
    });
  }
}
