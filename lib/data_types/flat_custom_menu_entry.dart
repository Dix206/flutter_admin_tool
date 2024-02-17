import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class FlatCustomMenuEntry extends Equatable {
  final String id;
  final String displayName;
  final Widget Function(BuildContext) contentBuilder;

  const FlatCustomMenuEntry({
    required this.id,
    required this.displayName,
    required this.contentBuilder,
  });

  @override
  List<Object?> get props => [id, displayName, contentBuilder];
}
