import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CmsUnauthorizedRoute extends Equatable {
  /// This is the path of the route. It shouldnt start with one of the following "/settings" "/overview", "/custom" and "/login".
  /// Otherwise there could be conflicts whith already existing routes.
  final String path;
  final Widget Function(BuildContext, GoRouterState) childBuilder;

  const CmsUnauthorizedRoute({
    required this.path,
    required this.childBuilder,
  });

  @override
  List<Object?> get props => [path, childBuilder];
}
