import 'package:equatable/equatable.dart';

/// These are the user infos that will be displayed in the menu. If a value is null, it will not be displayed.
class FlatUserInfos extends Equatable {
  final String? name;
  final String? email;
  final String? role;

  const FlatUserInfos({
    this.name,
    this.email,
    this.role,
  });

  bool hasAnyValue() => name != null || email != null || role != null;

  @override
  List<Object?> get props => [name, email, role];
}
