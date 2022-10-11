import 'package:flutter/material.dart';

class ColorPickerKeyboard extends StatelessWidget
    implements PreferredSizeWidget {
  static const double _kKeyboardHeight = 200;
  final Function(Color) onSelected;

  const ColorPickerKeyboard({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double itemWidth = screenWidth / 12;
    const double itemHeight = _kKeyboardHeight / 10;
    final List<Color> listColor = List.empty(growable: true);
    _createListColor(listColor);
    return Column(
      children: [
        const Spacer(),
        SizedBox(
          height: _kKeyboardHeight,
          child: Wrap(
            direction: Axis.vertical,
            children: listColor
                .map((color) => GestureDetector(
              onTap: () {
                onSelected.call(color);
              },
              child: Container(
                color: color,
                width: itemWidth,
                height: itemHeight,
              ),
            ))
                .toList(),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_kKeyboardHeight);

  List<Color> _getListShadeColor(MaterialColor materialColor) {
    return [
      materialColor.shade900,
      materialColor.shade800,
      materialColor.shade700,
      materialColor.shade600,
      materialColor.shade500,
      materialColor.shade400,
      materialColor.shade300,
      materialColor.shade200,
      materialColor.shade100,
      materialColor.shade50,
    ];
  }

  void _createListColor(List<Color> listColorInit) {
    listColorInit.addAll(_getListShadeColor(Colors.grey));
    listColorInit.addAll(_getListShadeColor(Colors.lightBlue));
    listColorInit.addAll(_getListShadeColor(Colors.blue));
    listColorInit.addAll(_getListShadeColor(Colors.deepPurple));
    listColorInit.addAll(_getListShadeColor(Colors.purple));
    listColorInit.addAll(_getListShadeColor(Colors.pink));
    listColorInit.addAll(_getListShadeColor(Colors.red));
    listColorInit.addAll(_getListShadeColor(Colors.deepOrange));
    listColorInit.addAll(_getListShadeColor(Colors.orange));
    listColorInit.addAll(_getListShadeColor(Colors.yellow));
    listColorInit.addAll(_getListShadeColor(Colors.lime));
    listColorInit.addAll(_getListShadeColor(Colors.green));
  }
}
