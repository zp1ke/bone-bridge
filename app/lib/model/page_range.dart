import 'dart:math';

class PageRange {
  final int start;
  final int end;

  PageRange._({required this.start, required this.end});

  static PageRange create({
    required int page,
    required int totalPages,
    required int visiblePages,
  }) {
    final pagesHalfWindow = visiblePages ~/ 2;
    var start = max(1, page - pagesHalfWindow);
    var end = max(1, min(totalPages, page + pagesHalfWindow));
    while (end - start < visiblePages - 1) {
      if (end < totalPages) {
        end += 1;
      } else if (start > 1) {
        start -= 1;
      } else {
        // nothing to do
        break;
      }
    }
    return PageRange._(start: start, end: end);
  }
}
