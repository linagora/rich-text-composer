
import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

class CustomVerticalDivider extends StatelessWidget {

  const CustomVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, color: CommonColor.colorBorderGray);
  }
}