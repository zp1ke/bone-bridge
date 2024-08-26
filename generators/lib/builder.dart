library generators;

import 'package:build/build.dart';

import 'src/builder/app_page_route_builder.dart';
import 'src/builder/app_routes_builder.dart';

Builder appPageRouteBuilder(BuilderOptions options) =>
    AppPageRouteBuilder(options: options);

Builder appRoutesBuilder(BuilderOptions options) => AppRoutesBuilder();
