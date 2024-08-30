import 'dart:math';

import 'package:flutter/material.dart';

import '../common/icon.dart';

class PaginationWidget extends StatelessWidget {
  final int page;
  final int totalPages;
  final _PageRange _pageRange;
  final Function(int) onPageChanged;

  PaginationWidget({
    super.key,
    required this.page,
    required this.totalPages,
    int visiblePages = 5,
    required this.onPageChanged,
  }) : _pageRange = _PageRange.create(
          page: page,
          totalPages: totalPages,
          visiblePages: visiblePages,
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /// Previous button
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: const Icon(AppIcons.paginationPrev),
              onPressed: page > 1 ? () => onPageChanged(page - 1) : null,
            ),
          ),

          for (int index = _pageRange.start; index < _pageRange.end; index++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextButton(
                  onPressed: index != page ? () => onPageChanged(index) : null,
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
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: IconButton(
              icon: const Icon(AppIcons.paginationNext),
              onPressed:
                  page < totalPages ? () => onPageChanged(page + 1) : null,
            ),
          ),
        ],
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
    final start = max(0, page - halfPagesWindow);
    var end = min(totalPages - 1, page + halfPagesWindow);
    while (end - start < visiblePages && end < totalPages - 1) {
      end += 1;
    }
    return _PageRange(start: start, end: end);
  }
}
