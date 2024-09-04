class DataPage<T> {
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPage &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          pageSize == other.pageSize;

  @override
  int get hashCode => page.hashCode ^ pageSize.hashCode;
}
