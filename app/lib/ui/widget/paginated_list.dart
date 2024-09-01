import 'package:flutter/material.dart';

import '../common/icon.dart';
import 'pagination.dart';
import 'responsive.dart';
import '../../model/data_page.dart';

typedef ItemBuilder<T> = Widget Function(T);

class PaginatedListWidget<T> extends StatelessWidget {
  final DataPage<T> dataPage;
  final bool fetching;
  final ItemBuilder<T> itemBuilder;
  final ScrollController scrollController;
  final Function(int) onPageChanged;

  const PaginatedListWidget({
    super.key,
    required this.dataPage,
    required this.fetching,
    required this.itemBuilder,
    required this.scrollController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPage.list.isEmpty) {
      return const Center(
        child: Text('Nothing here :( TODO L10N'),
      );
    }
    return ResponsiveWidget(
      small: (context) => itemsList(context),
      medium: (context) => paginationList(context),
    );
  }

  Widget paginationList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: itemsList(context),
        ),
        PaginationWidget(
          page: dataPage.page,
          totalPages: dataPage.totalCount ~/ dataPage.pageSize,
          onPageChanged: onPageChanged,
        ),
      ],
    );
  }

  Widget itemsList(BuildContext context) {
    final list = dataPage.list.toList();
    return ListView.separated(
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index == list.length) {
          return const ListTile(
            dense: true,
            title: Center(child: AppIcons.loadingSmall),
          );
        }
        return itemBuilder(list[index]);
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: list.length + (fetching ? 1 : 0),
    );
  }
}
