import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/data_page.dart';
import '../../model/route_state.dart';
import 'paginated_list.dart';
import 'responsive.dart';

class CrudPage<T> extends StatefulWidget {
  final int pageSize;
  final RouteConfigurer routeConfigurer;
  final DataFetcher<DataPage<T>> dataFetcher;
  final ItemBuilder<T> itemBuilder;

  const CrudPage({
    super.key,
    this.pageSize = 10,
    required this.routeConfigurer,
    required this.dataFetcher,
    required this.itemBuilder,
  });

  @override
  State<StatefulWidget> createState() => _CrudState<T>();
}

class _CrudState<T> extends State<CrudPage<T>> {
  final scrollController = ScrollController();

  var scrollPaginated = false;
  var dataPages = <DataPage<T>>{};

  var page = 0;
  var pageSize = 10;
  var lastPage = 10000;

  @override
  void initState() {
    super.initState();
    pageSize = widget.pageSize;
    Future.delayed(Duration.zero, () {
      initRoute();
      initScroll();
      fetchPage();
    });
  }

  void initRoute() {
    if (mounted) {
      final config = widget.routeConfigurer();
      final routeState = RouteState.of(context);
      if (config.canAddData == config.canReloadData) {
        routeState.canAddAndReload = config.canAddData;
      } else {
        routeState.canAdd = config.canAddData;
        routeState.canReload = config.canReloadData;
      }
    }
  }

  void initScroll() {
    scrollController.addListener(() async {
      final scrollPosition = scrollController.position;
      if (scrollPaginated &&
          scrollPosition.pixels == scrollPosition.maxScrollExtent &&
          page < lastPage) {
        setState(() {
          page += 1;
        });
        fetchPage();
      }
    });
  }

  void fetchPage({bool force = false}) async {
    if (!mounted) {
      return;
    }
    final routeState = RouteState.of(context);
    if (force || dataPages.isEmpty || page != dataPages.last.page) {
      routeState.fetching = true;
      final data = await widget.dataFetcher(page: page, pageSize: pageSize);
      routeState.fetching = false;
      dataPages.add(data);
      lastPage = data.totalCount ~/ pageSize;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dataPages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return ResponsiveWidget(
      small: (context) {
        scrollPaginated = true;
        return body();
      },
      medium: (context) {
        scrollPaginated = false;
        return body();
      },
    );
  }

  Widget body() {
    return Consumer<RouteState>(
      builder: (context, routeState, _) {
        return PaginatedListWidget<T>(
          dataPages: dataPages.toList(),
          fetching: routeState.fetching,
          itemBuilder: (item) => widget.itemBuilder(item, routeState.fetching),
          scrollController: scrollController,
          onPageChanged: (value) {
            setState(() {
              page = value;
            });
            fetchPage();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

typedef RouteConfigurer = RouteConfig Function();

typedef DataFetcher<T> = Future<T> Function({
  required int page,
  required int pageSize,
});

typedef ItemBuilder<T> = Widget Function(T item, bool fetching);

class RouteConfig {
  final bool canAddData;
  final bool canReloadData;

  RouteConfig({
    required this.canAddData,
    required this.canReloadData,
  });
}
