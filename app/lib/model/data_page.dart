class DataPage<T> {
  final Iterable<T> list;

  final int page;

  final int pageSize;

  final int totalCount;

  DataPage({
    required this.list,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  DataPage.empty()
      : list = [],
        page = -1,
        pageSize = 0,
        totalCount = 0;
}
