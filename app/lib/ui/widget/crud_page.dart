import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/data_page.dart';
import '../../state/route.dart';
import 'paginated_list.dart';
import 'responsive.dart';

abstract class CrudState<T> extends State<CrudPage<T>> {
  void fetchPage({bool force = false, bool reset = false});

  Future<T?> editItem([T? value]);
}

class CrudPage<T> extends StatefulWidget {
  final int pageSize;
  final RouteConfigurer routeConfigurer;
  final DataFetcher<DataPage<T>> dataFetcher;
  final ListItemBuilder<T> listItemBuilder;
  final EditItemBuilder<T> editItemBuilder;

  const CrudPage({
    super.key,
    this.pageSize = 10,
    required this.routeConfigurer,
    required this.dataFetcher,
    required this.listItemBuilder,
    required this.editItemBuilder,
  });

  @override
  State<StatefulWidget> createState() => _CrudState<T>();
}

class _CrudState<T> extends CrudState<T> {
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

  @override
  void fetchPage({bool force = false, bool reset = false}) async {
    if (!mounted) {
      return;
    }
    final routeState = RouteState.of(context);
    if (force || reset || dataPages.isEmpty || page != dataPages.last.page) {
      if (reset) {
        page = 0;
      }
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
          itemBuilder: (item) {
            return widget.listItemBuilder(context, item, routeState.fetching);
          },
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
  Future<T?> editItem([T? value]) async {
    RouteState.of(context).adding = true;
    final item = await showModalBottomSheet<T>(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return widget.editItemBuilder(context, value);
      },
    );
    if (mounted) {
      RouteState.of(context).adding = false;
    }
    return item;
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

typedef ListItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool fetching,
);

typedef EditItemBuilder<T> = Widget Function(BuildContext context, T? item);

class RouteConfig {
  final bool canAddData;
  final bool canReloadData;

  RouteConfig({
    required this.canAddData,
    required this.canReloadData,
  });
}
