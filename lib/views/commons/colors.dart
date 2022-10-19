import 'package:flutter/material.dart';

class CommonColor {
  static const colorBorderGray = Color(0xFFE4E4E4);
  static const colorBlue = Color(0xFF007AFF);
  static const colorIconSelect = Color(0xFF99A2AD);
  static const colorBackgroundSelect = Color(0xFFF2F3F5);
  static const colorStyleBlockQuote = Color(0xFFEEEEEE);
  static const colorBorderStyleCode = Color(0xFFCCCCCC);
  static const colorBackgroundStyleCode = Color(0xFFF5F5F5);
  static const colorBackgroundToolBar = Color(0xFFD2D5DC);

  static List<Color> get listColorsPicker {
    return [
      ...Colors.grey.listShadeColors,
      ...listMaterialColors.map((color) => color.shade900).toList(),
      ...listMaterialColors.map((color) => color.shade800).toList(),
      ...listMaterialColors.map((color) => color.shade700).toList(),
      ...listMaterialColors.map((color) => color.shade600).toList(),
      ...listMaterialColors.map((color) => color.shade500).toList(),
      ...listMaterialColors.map((color) => color.shade400).toList(),
      ...listMaterialColors.map((color) => color.shade300).toList(),
      ...listMaterialColors.map((color) => color.shade200).toList(),
      ...listMaterialColors.map((color) => color.shade100).toList(),
      ...listMaterialColors.map((color) => color.shade50).toList(),
    ];
  }

  static List<MaterialColor> get listMaterialColors {
    return [
      Colors.cyan,
      Colors.blue,
      Colors.deepPurple,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.deepOrange,
      Colors.orange,
      Colors.amber,
      Colors.yellow,
      Colors.lime,
      Colors.green
    ];
  }
}

extension MaterialColorExtension on MaterialColor {

  List<Color> get listShadeColors {
    return [
      const Color(0xFFFFFFFF),
      const Color(0xFFFCFCFC),
      shade50,
      shade100,
      shade200,
      shade300,
      shade400,
      shade500,
      shade600,
      shade700,
      shade800,
      shade900
    ];
  }
}