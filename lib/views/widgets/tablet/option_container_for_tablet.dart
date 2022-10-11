import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/widgets/clipper/clipper_stack.dart';

class OptionContainerForTablet extends StatelessWidget {
  const OptionContainerForTablet({
    Key? key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 32),
  }) : super(key: key);

  final String title;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipShadowPath(
      clipper: ClipperStack(),
      shadow: Shadow(
        blurRadius: 48,
        color: Colors.grey.shade500,
      ),
      child: SizedBox(
        height: 310,
        width: 320,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(color: CommonColor.colorBorderGray, height: 1),
              Expanded(
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
