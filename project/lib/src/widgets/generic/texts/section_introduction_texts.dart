import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/sizes.dart';

// Widgets.
import 'package:project/src/widgets/generic/texts/subtitle_section.dart';
import 'package:project/src/widgets/generic/texts/title_section.dart';

class SectionIntroductionTexts extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionIntroductionTexts({
    required this.title,
    required this.subtitle,
    super.key
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Sizes.margin4,
    children: [
      TitleSection(text: title),
      SubtitleSection(text: subtitle)
    ],
  );
}
