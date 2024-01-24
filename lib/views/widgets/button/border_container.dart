
import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

class BorderContainer extends StatelessWidget {

  final Widget child;

  const BorderContainer({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8),),
        border: Border.all(color: CommonColor.colorBorderGray)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: child,
      ),
    );
  }
}