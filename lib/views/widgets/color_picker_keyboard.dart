import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

class ColorPickerKeyboard extends StatelessWidget {
  final Function(Color)? onSelected;
  final Color currentColor;

  const ColorPickerKeyboard({
    required this.currentColor,
    Key? key,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Wrap(children: CommonColor.listColorsPicker
              .map((color) => _itemColorWidget(context, constraint.maxWidth, color))
              .toList()),
        ),
      );
    });
  }

  Widget _itemColorWidget(BuildContext context, double maxWidth, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected?.call(color),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: currentColor == color ? Colors.white : Colors.transparent,
              width: 3,
            ),
          ),
          width: (maxWidth / 12).floorToDouble(),
          height: 24.0,
        ),
      ),
    );
  }
}