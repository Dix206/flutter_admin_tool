import 'package:equatable/equatable.dart';

import 'package:flutter_cms/data_types/cms_attribute_value.dart';

class CmsObjectValueList extends Equatable {
  final List<CmsObjectValue> cmsObjectValues;
  final int overallPageCount;

  const CmsObjectValueList({
    required this.cmsObjectValues,
    required this.overallPageCount,
  });

  @override
  List<Object?> get props => [cmsObjectValues, overallPageCount];

  @override
  bool get stringify => true;
}

class CmsObjectValue extends Equatable {
  final String? id;
  final List<CmsAttributeValue> values;

  const CmsObjectValue({
    required this.id,
    required this.values,
  });

  S getAttributeValueByAttributeId<S extends Object?>(String id) {
    return values
        .firstWhere(
          (value) => value.id.toLowerCase() == id.toLowerCase(),
          orElse: () => throw Exception('CmsAttributeValue with id $id not found'),
        )
        .value as S;
  }

  CmsObjectValue copyWithNewValue(CmsAttributeValue newValue) {
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
