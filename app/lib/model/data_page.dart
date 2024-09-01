class DataPage<T> {
  List<T> _list;

  final int page;

  final int pageSize;

  final int totalCount;

  List<T> get list => _list;

  DataPage({
    required List<T> list,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  }) : _list = list;

  DataPage.empty()
      : _list = [],
        page = -1,
        pageSize = 0,
        totalCount = 0;

  void add(DataPage<T> other) {
    var set = _list.toSet();
    set.addAll(other._list);
    _list = set.toList();
  }
}
