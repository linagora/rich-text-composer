import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/logger.dart';
import 'package:rich_text_composer/views/widgets/clipper/clipper_stack.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_horizontal_divider.dart';

class OptionContainerForTablet extends StatelessWidget {
  const OptionContainerForTablet({
    Key? key,
    required this.title,
    required this.child,
    required this.richTextController,
    this.titleBack,
    this.maxWidth = 320,
    this.onCloseAction,
    this.onBackAction,
  }) : super(key: key);

  final String title;
  final String? titleBack;
  final Widget child;
  final RichTextController richTextController;
  final double maxWidth;
  final VoidCallback? onCloseAction;
  final VoidCallback? onBackAction;

  @override
  Widget build(BuildContext context) {
    log('OptionContainerForTablet::build TITLE = $title');
    return ClipShadowPath(
      clipper: ClipperStack(),
      shadow: Shadow(
        blurRadius: 48,
        color: Colors.grey.shade500,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        width: maxWidth,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 2 - 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: titleBack != null
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  if (titleBack != null && onBackAction != null)
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: onBackAction,
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                ImagePaths().icBack,
                                fit: BoxFit.fill,
                                width: 20,
                                height: 20,
                                package: packageName,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                titleBack!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: CommonColor.colorBlue))
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 72),
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
                  if (onCloseAction != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 12),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: onCloseAction,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              ImagePaths().icDismiss,
                              fit: BoxFit.fill,
                              width: 28,
                              height: 28,
                              package: packageName,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 72),
                ],
              ),
            ),
            const CustomHorizontalDivider(),
            Flexible(child: child)
        ]),
      ),
    );
  }
}
