import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/subtitle_section.dart';
import 'package:project/src/widgets/generic/texts/title_page.dart';

class SectionIntroductionTexts extends StatelessWidget {
  final String title;
  final String subtitle;
  final double horizontalPadding;
  final Widget? extraWidget;

  const SectionIntroductionTexts({
    required this.title,
    required this.subtitle,
    this.horizontalPadding = 0,
    this.extraWidget,
    super.key
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: extraWidget == null
      ? _createTexts()
      : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _createTexts()),
          const SizedBox(width: Sizes.margin12),

          extraWidget!
        ]
      )
  );

  // Method that creates the title and subtitle texts.
  Widget _createTexts() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin4,
    children: [
      if (title.isNotEmpty) TitlePage(text: title),
      if (subtitle.isNotEmpty) SubtitleSection(text: subtitle)
    ],
  );
}
