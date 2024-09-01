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
}
