
import 'package:flutter/material.dart';

typedef OnKeyboardButtonTapAction = Function();
typedef OnKeyboardButtonTapDownAction = Function(TapDownDetails details);

class KeyboardButton extends StatelessWidget {

  final OnKeyboardButtonTapAction? onTapAction;
  final OnKeyboardButtonTapDownAction? onTapDownAction;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const KeyboardButton({
    super.key,
    required this.child,
    this.onTapAction,
    this.onTapDownAction,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (margin != null) {
      return Padding(
        padding: margin!,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTapAction,
            onTapDown: onTapDownAction,
            customBorder: const CircleBorder(),
            child: padding != null
              ? Padding(padding: padding!, child: child)
              : child
          ),
        ),
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTapAction,
        onTapDown: onTapDownAction,
        customBorder: const CircleBorder(),
        child: padding != null
          ? Padding(padding: padding!, child: child)
          : child,
      ),
    );
  }
}