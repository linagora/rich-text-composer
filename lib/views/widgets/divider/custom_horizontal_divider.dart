
import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

class CustomHorizontalDivider extends StatelessWidget {

  const CustomHorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: CommonColor.colorBorderGray);
  }
}