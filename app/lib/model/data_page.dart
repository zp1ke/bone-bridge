class DataPage<T> implements Comparable<DataPage<T>> {
  final List<T> list;

  final int page;

  final int pageSize;

  final int totalCount;

  DataPage({
    required this.list,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  bool get isNotEmpty => list.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DataPage &&
        runtimeType == other.runtimeType &&
        page == other.page;
  }

  @override
  int get hashCode => page.hashCode ^ pageSize.hashCode;

  int get totalPages {
    if (totalCount == 0 || pageSize == 0) {
      return 0;
    }
    final totalPages = totalCount ~/ pageSize;
    if (totalCount % pageSize != 0) {
      return totalPages + 1;
    }
    return totalPages;
  }

  @override
  int compareTo(DataPage<T> other) {
    return page.compareTo(other.page);
  }

  @override
  String toString() {
    return 'DataPage{page: $page, size: $pageSize, total: $totalCount}';
  }
}
