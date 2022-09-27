import 'package:flutter/material.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/widgets/option_bottom_sheet.dart';

class ListHeaderStyle extends StatelessWidget {
  const ListHeaderStyle({Key? key, required this.itemSelected})
      : super(key: key);
  final Function(HeaderStyleType) itemSelected;

  @override
  Widget build(BuildContext context) {
    return OptionBottomSheet(
      title: 'Quick styles',
      child: ListView.builder(
        itemCount: HeaderStyleType.values.length,
        itemBuilder: (context, index) {
          final item = HeaderStyleType.values[index];
          return InkWell(
              onTap: () {
                itemSelected.call(item);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _buildItemDropdown(item),
              ));
        },
      ),
    );
  }

  Widget _buildItemDropdown(HeaderStyleType headerStyle) {
    switch (headerStyle) {
      case HeaderStyleType.blockquote:
        return Container(
            decoration: const BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color: CommonColor.colorStyleBlockQuote, width: 5.0))),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: _buildHeaderStyle(headerStyle.styleName,
                headerStyle.textSize, headerStyle.fontWeight));
      case HeaderStyleType.code:
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: CommonColor.colorBorderStyleCode, width: 1.0),
                color: CommonColor.colorBackgroundStyleCode),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: _buildHeaderStyle(headerStyle.styleName,
                headerStyle.textSize, headerStyle.fontWeight));
      default:
        return _buildHeaderStyle(headerStyle.styleName, headerStyle.textSize,
            headerStyle.fontWeight);
    }
  }

  Widget _buildHeaderStyle(String name, double size, FontWeight fontWeight) {
    return Text(name,
        style: TextStyle(
            fontSize: size, fontWeight: fontWeight, color: Colors.black),
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis);
  }
}
