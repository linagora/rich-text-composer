import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';

class OptionBottomSheet extends StatelessWidget {
  const OptionBottomSheet({
    Key? key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  }) : super(key: key);

  final String title;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        left: ResponsiveUtils().isPortraitMobile(context),
        right: ResponsiveUtils().isPortraitMobile(context),
        child: Container(
          color: Colors.transparent,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 40),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 52,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                            ImagePaths().icDismiss,
                            fit: BoxFit.fill,
                            width: 24,
                            height: 24,
                            package: packageName,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(color: CommonColor.colorBorderGray, height: 1)
                ]),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: padding,
                    child: child,
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}
