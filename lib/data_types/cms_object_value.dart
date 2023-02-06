import 'package:equatable/equatable.dart';

import 'package:flutter_cms/data_types/cms_attribut_value.dart';
import 'package:flutter_cms/extensions/iterable_extensions.dart';

class CmsObjectValueList<T extends Object> extends Equatable {
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
  final Object? id;
  final List<CmsAttributValue> values;

  const CmsObjectValue({
    required this.id,
    required this.values,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      ...values.asMap().map(
            (_, value) => MapEntry(value.name, value.value),
          ),
    };
  }

  CmsAttributValue? getAttributeValueByName(String name) {
    final k = 0;
    return values.firstWhereOrNull((value) => value.name.toLowerCase() == name.toLowerCase());
  }

  Object? getValueByName(String name) {
    final att = values.firstWhereOrNull((value) => value.name.toLowerCase() == name.toLowerCase());
    final value = values.firstWhereOrNull((value) => value.name.toLowerCase() == name.toLowerCase())?.value;
    final k = 0;
    return values.firstWhereOrNull((value) => value.name.toLowerCase() == name.toLowerCase())?.value;
  }

  CmsObjectValue copyWithNewValue(CmsAttributValue newValue) {
    return CmsObjectValue(
      id: id,
      values: values.map(
        (value) {
          if (value.name == newValue.name) {
            return newValue;
          } else {
            return value;
          }
        },
      ).toList(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, values];
}
