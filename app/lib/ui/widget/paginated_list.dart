import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../common/icon.dart';
import 'pagination.dart';
import 'responsive.dart';
import '../../model/data_page.dart';

typedef ItemBuilder<T> = Widget Function(T);

class PaginatedListWidget<T> extends StatelessWidget {
  final List<DataPage<T>> dataPages;
  final int pageIndex;
  final bool fetching;
  final ItemBuilder<T> itemBuilder;
  final ScrollController scrollController;
  final Function(int) onPageChanged;

  PaginatedListWidget({
    super.key,
    required List<DataPage<T>> dataPages,
    required this.pageIndex,
    required this.fetching,
    required this.itemBuilder,
    required this.scrollController,
    required this.onPageChanged,
  }) : dataPages = dataPages.sortedBy<num>((dataPage) => dataPage.page);

  @override
  Widget build(BuildContext context) {
    if (dataPages.isEmpty) {
      return emptyBody(context);
    }
    return ResponsiveWidget(
      small: (context) => itemsList(context),
      medium: (context) => paginationList(context, 3),
      large: (context) => paginationList(context, 2),
    );
  }

  Widget emptyBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          L10n.of(context).nothingHere,
          textScaler: const TextScaler.linear(1.5),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(L10n.of(context).goAddContent),
        ),
      ],
    );
  }

  Widget itemsList(BuildContext context, [DataPage<T>? dataPage]) {
    final list = <T>[];
    if (dataPage != null) {
      list.addAll(dataPage.list);
    } else if (dataPages.isNotEmpty) {
      for (var dataPage in dataPages) {
        list.addAll(dataPage.list);
      }
    }
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

  Widget paginationList(BuildContext context, int visiblePages) {
    final dataPage = dataPages[pageIndex];
    return Column(
      children: [
        Expanded(
          child: itemsList(context, dataPage),
        ),
        PaginationWidget(
          enabled: !fetching,
          page: dataPage.page,
          totalPages: dataPage.totalCount ~/ dataPage.pageSize - 1,
          visiblePages: visiblePages,
          onPageChanged: onPageChanged,
        ),
      ],
    );
  }
}
