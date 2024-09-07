import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../model/page_range.dart';
import '../common/icon.dart';

class PaginationWidget extends StatelessWidget {
  final bool enabled;
  final int page;
  final int totalPages;
  final PageRange _pageRange;
  final Function(int) onPageChanged;
  final MainAxisAlignment mainAxisAlignment;

  PaginationWidget({
    super.key,
    this.enabled = true,
    required int page,
    required int totalPages,
    required int visiblePages,
    required this.onPageChanged,
    this.mainAxisAlignment = MainAxisAlignment.center,
  })  : page = page + 1,
        totalPages = totalPages + 1,
        _pageRange = PageRange.create(
          page: page,
          totalPages: totalPages,
          visiblePages: visiblePages,
        );

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          /// First page button
          tooltipButton(
            message: l10n.goFirstPage,
            enabled: _pageRange.start > 1,
            iconData: AppIcons.paginationGoFirst,
            onAction: () => onPageChanged(0),
            invisibleIfDisabled: true,
          ),

          /// Previous button
          tooltipButton(
            message: l10n.goPreviousPage,
            enabled: page > 1,
            iconData: AppIcons.paginationPrev,
            onAction: () => onPageChanged(page - 2),
          ),

          for (int index = _pageRange.start; index <= _pageRange.end; index++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CircleAvatar(
                  backgroundColor: index != page
                      ? Colors.transparent
                      : theme.disabledColor,
                  child: IconButton(
                    onPressed: enabled && index != page
                        ? () => onPageChanged(index - 1)
                        : null,
                    icon: Text(
                      '$index',
                      style: TextStyle(
                        fontWeight: index == page
                            ? FontWeight.w700
                            : FontWeight.normal,
                        textBaseline: TextBaseline.ideographic,
                      ),
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
            onAction: () => onPageChanged(page),
          ),

          /// Last page button
          tooltipButton(
            message: l10n.goLastPage,
            enabled: _pageRange.end < totalPages,
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
