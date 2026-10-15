import 'package:flutter/material.dart';

// Commons.
import 'package:project/src/commons/constants/custom_colors.dart';
import 'package:project/src/commons/constants/numbers.dart';
import 'package:project/src/commons/constants/sizes.dart';
import 'package:project/src/commons/constants/strings.dart';

// Widgets.
import 'package:project/src/widgets/generic/loaders/skeleton_custom.dart';
import 'package:project/src/widgets/generic/texts/text_not_found.dart';

class PaginatedListViewCustom<T> extends StatefulWidget {
  final Stream<List<T>> itemsStream;
  final Stream<String> loadingTextStream;
  final int Function() getCount;
  final Future<void> Function() onLoadMore;
  final Widget Function(T item, int index, bool isLast) createItem;
  final T Function() createPlaceholder;
  final int skeletonLength;
  final String? emptyText;
  final Widget? header;
  final EdgeInsetsGeometry? padding;

  const PaginatedListViewCustom({
    required this.itemsStream,
    required this.loadingTextStream,
    required this.getCount,
    required this.onLoadMore,
    required this.createItem,
    required this.createPlaceholder,
    this.skeletonLength = Numbers.skeletonPageListLength,
    this.emptyText,
    this.header,
    this.padding,
    super.key
  });

  @override
  State<PaginatedListViewCustom<T>> createState() => _PaginatedListViewCustomState<T>();
}

class _PaginatedListViewCustomState<T> extends State<PaginatedListViewCustom<T>> {
  late ScrollController scrollController;

  late List<T> items;

  late bool isLoadingMore;

  late bool isRequesting;

  @override
  void initState() {
    super.initState();

    items = [];
    isLoadingMore = false;
    isRequesting = false;
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (isRequesting || isLoadingMore || items.length >= widget.getCount() || scrollController.offset < scrollController.position.maxScrollExtent) {
        return;
      }

      _loadMore();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<T>>(
    stream: widget.itemsStream,
    builder: (BuildContext context, AsyncSnapshot<List<T>> itemsSnapshot) => StreamBuilder<String>(
      stream: widget.loadingTextStream,
      builder: (BuildContext context, AsyncSnapshot<String> loadingTextSnapshot) {
        items = itemsSnapshot.data ?? <T>[];
        isLoadingMore = (loadingTextSnapshot.data ?? Strings.emptyString).isNotEmpty;

        return _createList(hasData: itemsSnapshot.hasData);
      }
    )
  );

  // Method that creates the list: header, items (or placeholders while drawn as skeleton, or the not found text) and the loader at the end.
  Widget _createList({ required bool hasData }) {
    final List<T> drawnItems = SkeletonCustom.getItems<T>(context: context, items: items, length: widget.skeletonLength, createPlaceholder: widget.createPlaceholder);
    final bool showNotFound = drawnItems.isEmpty && hasData;
    final bool showLoader = isLoadingMore && items.isNotEmpty;
    final int headerCount = widget.header == null ? 0 : 1;

    return ListView.builder(
      controller: SkeletonCustom.isEnabled(context) ? null : scrollController,
      physics: const BouncingScrollPhysics(),
      padding: widget.padding,
      itemCount: headerCount + (showNotFound ? 1 : drawnItems.length) + (showLoader ? 1 : 0),
      itemBuilder: (BuildContext context, int index) => _createElement(
        index: index - headerCount,
        items: drawnItems,
        showNotFound: showNotFound,
        showLoader: showLoader
      )
    );
  }

  // Method that creates the element at the given index: the header, the not found text, an item or the loader.
  Widget _createElement({ required int index, required List<T> items, required bool showNotFound, required bool showLoader }) {
    if (index < 0) {
      return widget.header!;
    }

    if (showNotFound) {
      return TextNotFound(text: widget.emptyText);
    }

    if (index == items.length) {
      return _createLoaderMore();
    }

    return widget.createItem(items[index], index, index == items.length - 1 && !showLoader);
  }

  // Method that loads the next page of items.
  Future<void> _loadMore() async {
    isRequesting = true;

    await widget.onLoadMore();

    if (!mounted) {
      return;
    }

    isRequesting = false;
  }

  // Method that creates the loader shown at the end of the list while the next page is loading.
  Widget _createLoaderMore() => const Padding(
    padding: EdgeInsets.only(top: Sizes.margin16),
    child: Center(child: CircularProgressIndicator(color: CustomColors.lime))
  );
}
