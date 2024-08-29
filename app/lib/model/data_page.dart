abstract class DataPage<T> {
  Iterable<T> get list;

  int get page;

  int get pageSize;

  int get totalCount;
}
