import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../common/icon.dart';

class PaginationWidget extends StatelessWidget {
  final bool enabled;
  final int page;
  final int totalPages;
  final _PageRange _pageRange;
  final Function(int) onPageChanged;
  final MainAxisAlignment mainAxisAlignment;

  PaginationWidget({
    super.key,
    this.enabled = true,
    required this.page,
    required this.totalPages,
    int visiblePages = 5,
    required this.onPageChanged,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : _pageRange = _PageRange.create(
          page: page,
          totalPages: totalPages,
          visiblePages: visiblePages,
        );

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          /// First page button
          tooltipButton(
            message: l10n.goFirstPage,
            enabled: _pageRange.start > 0,
            iconData: AppIcons.paginationGoFirst,
            onAction: () => onPageChanged(0),
            invisibleIfDisabled: true,
          ),

          /// Previous button
          tooltipButton(
            message: l10n.goPreviousPage,
            enabled: page > 0,
            iconData: AppIcons.paginationPrev,
            onAction: () => onPageChanged(page - 1),
          ),

          for (int index = _pageRange.start; index <= _pageRange.end; index++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextButton(
                  onPressed: enabled && index != page
                      ? () => onPageChanged(index)
                      : null,
                  child: Text(
                    '${index + 1}',
                    textScaler: TextScaler.linear(index == page ? 1.5 : 1),
                    style: TextStyle(
                      fontWeight:
                          index == page ? FontWeight.w700 : FontWeight.normal,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                ),
              ),
            ),

          /// Next button
          tooltipButton(
            message: l10n.goNextPage,
            enabled: page < totalPages,
            iconData: AppIcons.paginationNext,
            onAction: () => onPageChanged(page + 1),
          ),

          /// Last page button
          tooltipButton(
            message: l10n.goLastPage,
            enabled: _pageRange.end < totalPages - 1,
            iconData: AppIcons.paginationGoLast,
            onAction: () => onPageChanged(totalPages - 1),
            invisibleIfDisabled: true,
          ),
        ],
      ),
    );
  }

  Widget tooltipButton({
    required String message,
    required bool enabled,
    required IconData iconData,
    required VoidCallback onAction,
    bool invisibleIfDisabled = false,
  }) {
    final invisible = invisibleIfDisabled && !enabled;
    final button = IconButton(
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

class _PageRange {
  final int start;
  final int end;

  _PageRange({required this.start, required this.end});

  static _PageRange create({
    required int page,
    required int totalPages,
    required int visiblePages,
  }) {
    final halfPagesWindow = visiblePages ~/ 2;
    var start = max(0, page - halfPagesWindow);
    var end = min(totalPages - 1, page + halfPagesWindow);
    while (end - start < visiblePages) {
      if (end < totalPages - 1) {
        end += 1;
      } else if (start > 0) {
        start -= 1;
      }
    }
    return _PageRange(start: start, end: end);
  }
}
