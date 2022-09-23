library keyboard_richtext;

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rich_text_composer/richtext_append_controller.dart';

class KeyboardRichText extends StatelessWidget {
  const KeyboardRichText({
    Key? key,
    required this.child,
    required this.richTextAppendController,
    required this.backgroundKeyboardToolBarColor,
    required this.keyBroadToolbar,
    this.heightToolBar = 48,
  }) : super(key: key);

  final Widget child;
  final Widget keyBroadToolbar;
  final RichTextAppendController richTextAppendController;
  final Color backgroundKeyboardToolBarColor;
  final double? heightToolBar;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        body: child,
        bottomSheet: StreamBuilder(
          stream: richTextAppendController.richTextAppendStream,
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
