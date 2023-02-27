import 'package:equatable/equatable.dart';

import 'package:flat/data_types/flat_attribute_value.dart';

class FlatObjectValueList extends Equatable {
  final List<FlatObjectValue> flatObjectValues;
  final int overallPageCount;

  const FlatObjectValueList({
    required this.flatObjectValues,
    required this.overallPageCount,
  });

  @override
  List<Object?> get props => [flatObjectValues, overallPageCount];

  @override
  bool get stringify => true;
}

class FlatObjectValue extends Equatable {
  final String? id;
  final List<FlatAttributeValue> values;

  const FlatObjectValue({
    required this.id,
    required this.values,
  });

  S getAttributeValueByAttributeId<S extends Object?>(String id) {
    return values
        .firstWhere(
          (value) => value.id.toLowerCase() == id.toLowerCase(),
          orElse: () => throw Exception('FlatAttributeValue with id $id not found'),
        )
        .value as S;
  }

  FlatObjectValue copyWithNewValue(FlatAttributeValue newValue) {
    return FlatObjectValue(
      id: id,
      values: values
          .map(
            (value) => value.id.toLowerCase() == newValue.id.toLowerCase() ? newValue : value,
          )
          .toList(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, values];
}