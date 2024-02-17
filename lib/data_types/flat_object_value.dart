import 'package:equatable/equatable.dart';

import 'package:flutter_admin_tool/data_types/flat_attribute_value.dart';

class FlatOffsetObjectValueList extends Equatable {
  final List<FlatObjectValue> flatObjectValues;
  final int overallPageCount;

  const FlatOffsetObjectValueList({
    required this.flatObjectValues,
    required this.overallPageCount,
  });

  @override
  List<Object?> get props => [flatObjectValues, overallPageCount];

  @override
  bool get stringify => true;
}

class FlatCurserObjectValueList extends Equatable {
  final List<FlatObjectValue> flatObjectValues;
  final bool hasMoreItems;

  const FlatCurserObjectValueList({
    required this.flatObjectValues,
    required this.hasMoreItems,
  });

  @override
  List<Object?> get props => [flatObjectValues, hasMoreItems];

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
    final attributeValue = values.firstWhere(
      (value) => value.id.toLowerCase() == id.toLowerCase(),
      orElse: () => throw Exception('FlatAttributeValue with id $id not found'),
    );

    if (attributeValue.value is! S) {
      throw Exception(
        'FlatAttributeValue with id $id is not of type $S but of type ${attributeValue.value.runtimeType}',
      );
    }

    return attributeValue.value as S;
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
