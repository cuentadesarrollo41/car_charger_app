import 'dart:async';
import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';

// Widgets.
import 'package:project/src/widgets/generic/containers/conditional_widget.dart';
import 'package:project/src/widgets/generic/scrollable/page_indicators.dart';

class PageViewCustom extends StatefulWidget {
  final List<Widget> slides;
  final int startPage;
  final bool isAutoScroll;
  final bool allowManualScroll;
  final int delayAutoScroll;
  final double pageIndicatorHeight;
  final double pageIndicatorWidth;
  final Color activeIndicatorColor;
  final Color inactiveIndicatorColor;

  final double height;

  const PageViewCustom({
    required this.slides,
    this.startPage = 0,
    this.isAutoScroll = false,
    this.allowManualScroll = true,
    this.delayAutoScroll = 2000,
    this.pageIndicatorHeight = Numbers.noValueDouble,
    this.pageIndicatorWidth = Numbers.noValueDouble,
    this.activeIndicatorColor = CustomColors.lime,
    this.inactiveIndicatorColor = CustomColors.backgroundCard,
    required this.height,
    super.key
  });

  @override
  State<PageViewCustom> createState() => _PageViewCustomState();
}

class _PageViewCustomState extends State<PageViewCustom> {
  late PageController pageController;

  late int page;

  @override
  void initState() {
    page = widget.startPage;
    pageController = PageController(initialPage: page);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Enable autoScroll.
      if (widget.isAutoScroll) {
        Timer.periodic(Duration(milliseconds: widget.delayAutoScroll), (Timer timer) {
          if (!mounted) {
            return;
          }

          page = page < widget.slides.length - 1 ? (page + 1) : 0;
          pageController.animateToPage(page, duration: const Duration(milliseconds: Numbers.delayScroll), curve: Curves.easeIn);
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView(
            physics: widget.allowManualScroll
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: widget.slides,
            onPageChanged: (int? newPage) => _onPageChanged(newPage!),
          ),
        ),

        ConditionalWidget(
          showChild: widget.pageIndicatorHeight > 0 && widget.pageIndicatorWidth > 0,
          createChild: () => PageIndicators(
            currentPage: page,
            totalPages: widget.slides.length,
            pageIndicatorWidth: widget.pageIndicatorWidth,
            pageIndicatorHeight: widget.pageIndicatorHeight,
            activeIndicatorColor: widget.activeIndicatorColor,
            inactiveIndicatorColor: widget.inactiveIndicatorColor,
            maxVisibleIndicators: 5,
          )
        )
      ],
    );
  }

  // ***************************************************************************
  // On change listeners.
  // ***************************************************************************
  void _onPageChanged(int newPage) {
    page = newPage;
    setState(() {});
  }
}
