import 'package:equatable/equatable.dart';

import 'package:flutter_cms/data_types/cms_attribut_value.dart';

class CmsObjectValueList extends Equatable {
  final List<CmsObjectValue> cmsObjectValues;
  final bool hasMoreItems;

  const CmsObjectValueList({
    required this.cmsObjectValues,
    required this.hasMoreItems,
  });

  @override
  List<Object?> get props => [cmsObjectValues, hasMoreItems];

  @override
  bool get stringify => true;
}

class CmsObjectValue extends Equatable {
  final String? id;
  final List<CmsAttributValue> values;

  const CmsObjectValue({
    required this.id,
    required this.values,
  });

  S getAttributValueByAttributId<S extends Object?>(String id) {
    return values
        .firstWhere(
          (value) => value.id.toLowerCase() == id.toLowerCase(),
          orElse: () => throw Exception('CmsAttributValue with id $id not found'),
        )
        .value as S;
  }

  CmsObjectValue copyWithNewValue(CmsAttributValue newValue) {
    return CmsObjectValue(
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
