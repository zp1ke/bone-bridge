import 'package:app/model/page_range.dart';
import 'package:test/test.dart';

void main() {
  test('from 1 page and 3 visible get range for 1', () {
    final pageRange = PageRange.create(page: 1, totalPages: 1, visiblePages: 3);
    expect(pageRange.start, equals(1));
    expect(pageRange.end, equals(1));
  });

  test('from 5 pages, active last and 3 visible get range for last 3', () {
    final pageRange = PageRange.create(page: 5, totalPages: 5, visiblePages: 3);
    expect(pageRange.start, equals(3));
    expect(pageRange.end, equals(5));
  });
}
