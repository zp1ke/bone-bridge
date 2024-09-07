import 'package:app/model/data_page.dart';
import 'package:test/test.dart';

void main() {
  test('total pages calculation', () {
    var dataPage = DataPage<int>(list: [], page: 0, pageSize: 2, totalCount: 4);
    expect(dataPage.totalPages, equals(2));

    dataPage = DataPage<int>(list: [], page: 0, pageSize: 2, totalCount: 5);
    expect(dataPage.totalPages, equals(3));

    dataPage = DataPage<int>(list: [], page: 0, pageSize: 2, totalCount: 6);
    expect(dataPage.totalPages, equals(3));

    dataPage = DataPage<int>(list: [], page: 0, pageSize: 2, totalCount: 7);
    expect(dataPage.totalPages, equals(4));
  });
}
