import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/widgets/clipper/triangle_clipper.dart';

class OptionContainerForTablet extends StatelessWidget {
  const OptionContainerForTablet({
    Key? key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  final String title;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 290,
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
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              color: Colors.white,
              height: 10,
              width: 20,
            ),
          ),
        ),
      ],
    );
  }
}
