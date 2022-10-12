library keyboard_richtext;

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:rich_text_composer/richtext_controller.dart';

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
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Stack(children: <Widget>[
        SizedBox(
          height: double.infinity,
          child: child,
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 0,
          right: 0,
          child: StreamBuilder(
            stream: richTextController.richTextStream,
            builder: (context, snapshot) {
              return Visibility(
                visible: snapshot.hasData &&
                    snapshot.data == true &&
                    isKeyboardVisible,
                child: keyBroadToolbar,
              );
            },
          ),
        ),

      ]);
    });
  }
}
