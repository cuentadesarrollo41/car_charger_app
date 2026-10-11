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

  const SectionIntroductionTexts({
    required this.title,
    required this.subtitle,
    this.horizontalPadding = 0,
    super.key
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Sizes.margin4,
      children: [
        if (title.isNotEmpty) TitlePage(text: title),
        if (subtitle.isNotEmpty) SubtitleSection(text: subtitle)
      ],
    ),
  );
}
