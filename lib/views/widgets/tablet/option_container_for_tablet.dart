import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/clipper/clipper_stack.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';

class OptionContainerForTablet extends StatelessWidget {
  OptionContainerForTablet({
    Key? key,
    required this.title,
    required this.child,
    this.titleBack,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 32),
    required this.richTextController,
  }) : super(key: key);

  final String title;
  final String? titleBack;
  final Widget child;
  final RichTextController richTextController;
  final EdgeInsets padding;
  final ImagePaths _imagePaths = ImagePaths();

  @override
  Widget build(BuildContext context) {
    return ClipShadowPath(
      clipper: ClipperStack(),
      shadow: Shadow(
        blurRadius: 48,
        color: Colors.grey.shade500,
      ),
      child: SizedBox(
        height: 310,
        width: 320,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: titleBack != null
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    titleBack != null
                        ? InkWell(
                          onTap: () {
                            richTextController
                                .currentIndexStackOverlayRichTextForTablet
                                .value = 0;
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                _imagePaths.icBack,
                                fit: BoxFit.fill,
                                width: 24,
                                height: 24,
                                package: packageName,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                titleBack!,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: CommonColor.colorBlue),
                              )
                            ],
                          ),
                        )
                        : const SizedBox(width: 72),
                    Expanded(
                      flex: 1,
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
                    Container(
                      padding: const EdgeInsets.only(left: 48),
                      width: 72,
                      child: InkWell(
                        onTap: () {
                          richTextController
                              .applyRichTextOptionForTablet.value = false;
                        },
                        child: SvgPicture.asset(
                          _imagePaths.icDismiss,
                          fit: BoxFit.fill,
                          width: 24,
                          height: 24,
                          package: packageName,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(color: CommonColor.colorBorderGray, height: 1),
              Expanded(
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
