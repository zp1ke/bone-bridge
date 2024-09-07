import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../model/page_range.dart';
import '../common/icon.dart';

class PaginationWidget extends StatelessWidget {
  static const String gotoFirstPageKey = 'goto-first';
  static const String gotoPreviousPageKey = 'goto-prev';
  static const String gotoLastPageKey = 'goto-last';
  static const String gotoNextPageKey = 'goto-next';
  static const String gotoPageKey = 'goto';

  final bool enabled;
  final bool zeroBased;
  final int page;
  final int totalCount;
  final int pageSize;
  final List<int> pageSizes;
  final int totalPages;
  final String itemLabel;
  final PageRange _pageRange;
  final Function(int) onPageChanged;
  final String buttonsKeyPrefix;

  PaginationWidget({
    super.key,
    this.enabled = true,
    this.zeroBased = true,
    required int page,
    required this.totalCount,
    required this.pageSize,
    List<int>? pageSizes,
    required this.totalPages,
    required this.itemLabel,
    required int visiblePages,
    required this.onPageChanged,
    this.buttonsKeyPrefix = 'pagination',
  })  : page = page + (zeroBased ? 1 : 0),
        pageSizes = _pagesSizesOf(pageSize, pageSizes),
        _pageRange = PageRange.create(
          page: page + (zeroBased ? 1 : 0),
          totalPages: totalPages,
          visiblePages: visiblePages,
        );

  static String buttonPageKey(String buttonsKeyPrefix, int page) {
    return '$buttonsKeyPrefix-$gotoPageKey-$page';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _perPageWidget(context),
          _pagesWidget(context),
        ],
      ),
    );
  }

  Widget _perPageWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<int>(
          value: pageSize,
          items: pageSizes
              .map(
                (size) => DropdownMenuItem<int>(
                  value: size,
                  enabled: enabled && size != pageSize,
                  child: Text(size.toString()),
                ),
              )
              .toList(),
          onChanged: enabled
              ? (value) {
                  // TODO: onChangePageSize
                }
              : null,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            L10n.of(context).paginationPerPageAndTotalCount(
              itemLabel,
              totalCount,
            ),
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ),
      ],
    );
  }

  Widget _pagesWidget(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// First page button
        tooltipButton(
          key: '$buttonsKeyPrefix-$gotoFirstPageKey',
          message: l10n.goFirstPage,
          enabled: enabled && _pageRange.start > 1,
          iconData: AppIcons.paginationGoFirst,
          onAction: () => onPageChanged(zeroBased ? 0 : 1),
          invisibleIfDisabled: true,
        ),

        /// Previous button
        tooltipButton(
          key: '$buttonsKeyPrefix-$gotoPreviousPageKey',
          message: l10n.goPreviousPage,
          enabled: enabled && page > 1,
          iconData: AppIcons.paginationPrev,
          onAction: () => onPageChanged(page - (zeroBased ? 2 : 1)),
        ),

        for (int index = _pageRange.start; index <= _pageRange.end; index++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: CircleAvatar(
                backgroundColor:
                    index != page ? Colors.transparent : theme.disabledColor,
                child: IconButton(
                  key: ValueKey(
                    PaginationWidget.buttonPageKey(buttonsKeyPrefix, index),
                  ),
                  onPressed: enabled && index != page
                      ? () => onPageChanged(index - (zeroBased ? 1 : 0))
                      : null,
                  icon: Text(
                    '$index',
                    style: TextStyle(
                      fontWeight:
                          index == page ? FontWeight.w700 : FontWeight.normal,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                ),
              ),
            ),
          ),

        /// Next button
        tooltipButton(
          key: '$buttonsKeyPrefix-$gotoNextPageKey',
          message: l10n.goNextPage,
          enabled: enabled && page < totalPages,
          iconData: AppIcons.paginationNext,
          onAction: () => onPageChanged(page + (zeroBased ? 0 : 1)),
        ),

        /// Last page button
        tooltipButton(
          key: '$buttonsKeyPrefix-$gotoLastPageKey',
          message: l10n.goLastPage,
          enabled: enabled && _pageRange.end < totalPages,
          iconData: AppIcons.paginationGoLast,
          onAction: () => onPageChanged(totalPages - (zeroBased ? 1 : 0)),
          invisibleIfDisabled: true,
        ),
      ],
    );
  }

  Widget tooltipButton({
    required String key,
    required String message,
    required bool enabled,
    required IconData iconData,
    required VoidCallback onAction,
    bool invisibleIfDisabled = false,
  }) {
    final invisible = invisibleIfDisabled && !enabled;
    final button = IconButton(
      key: ValueKey(key),
      icon: Icon(
        iconData,
        color: invisible ? Colors.transparent : null,
      ),
      onPressed: this.enabled && enabled ? onAction : null,
    );

    if (invisible) {
      return button;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Tooltip(
        message: message,
        child: button,
      ),
    );
  }
}

List<int> _pagesSizesOf(int pageSize, List<int>? pageSizes) {
  final list = pageSizes?.toSet() ?? <int>{};
  list.add(pageSize);
  return list.toList().sorted((s1, s2) => s1.compareTo(s2));
}
