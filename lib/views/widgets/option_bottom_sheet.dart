import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';

class OptionBottomSheet extends StatelessWidget {
  OptionBottomSheet({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;
  final ImagePaths _imagePaths = ImagePaths();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
              ),
              Expanded(
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
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  _imagePaths.icDismiss,
                  fit: BoxFit.fill,
                  width: 24,
                  height: 24,
                  package: packageName,
                ),
              ),
            ],
          ),
        ),
        Container(color: const Color(0xFFE4E4E4), height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ],
    );
  }
}
