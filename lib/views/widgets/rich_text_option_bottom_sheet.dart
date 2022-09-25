import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/option_bottom_sheet.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';

class RichTextOptionBottomSheet extends StatelessWidget {
  final String title;
  final ImagePaths _imagePaths = ImagePaths();

  RichTextOptionBottomSheet({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return OptionBottomSheet(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecialStyle(),
          const SizedBox(height: 8),
          _buildQuickStyle(),
          const SizedBox(height: 8),

        ],
      ),
    );
  }

  Widget _buildBorderContainer(Widget child) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(color: CommonColor.colorBorderGray)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: child,
      ),
    );
  }

  Widget _buildSpecialStyle() {
    return _buildBorderContainer(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(true, () {}, _imagePaths.icBoldStyle),
          _buildVerticalDivider(),
          _buildIconButton(true, () {}, _imagePaths.icItalicStyle),
          _buildVerticalDivider(),
          _buildIconButton(false, () {}, _imagePaths.icStrikeThrough),
          _buildVerticalDivider(),
          _buildIconButton(false, () {}, _imagePaths.icUnderLine),
        ],
      ),
    );
  }

  Widget _buildQuickStyle() {
    return _buildBorderContainer(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Quick styles',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CommonColor.colorIconSelect,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          LimitedBox(
            maxWidth: 28,
            maxHeight: 28,
            child: SvgPicture.asset(
              _imagePaths.icArrowRight,
              package: packageName,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlignStyle() {
    return _buildBorderContainer(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Quick styles',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CommonColor.colorIconSelect,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          LimitedBox(
            maxWidth: 28,
            maxHeight: 28,
            child: SvgPicture.asset(
              _imagePaths.icArrowRight,
              package: packageName,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildVerticalDivider() => Container(
        width: 1,
        color: CommonColor.colorBorderGray,
      );

  Widget _buildIconButton(
    bool isSelected,
    VoidCallback onTap,
    String asset,
  ) {
    return Expanded(
      child: InkWell(
        child: Container(
          color: isSelected ? CommonColor.colorBackgroundSelect : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          height: double.infinity,
          child: LimitedBox(
            maxWidth: 28,
            maxHeight: 28,
            child: SvgPicture.asset(
              asset,
              color: isSelected ? CommonColor.colorIconSelect : null,
              package: packageName,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
