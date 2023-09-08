import 'package:firebase_example/user/department.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_value.dart';
import 'package:flutter_admin_tool/data_types/flat_object_value.dart';

class AppUserDto {
  final String id;
  final String name;
  final List<String>? departmentsWithAccess;

  const AppUserDto({
    required this.id,
    required this.name,
    required this.departmentsWithAccess,
  });

  FlatObjectValue toFlatObjectValue() {
    return FlatObjectValue(
      id: id,
      values: [
        FlatAttributeValue(id: 'id', value: id),
        FlatAttributeValue(id: 'name', value: name),
        FlatAttributeValue(
          id: 'departmentsWithAccess',
          value: departmentsWithAccess?.map((e) => Department.values.byName(e)).toList() ?? [],
        ),
      ],
    );
  }

  factory AppUserDto.fromFlatObjectValue({
    required FlatObjectValue flatObjectValue,
    String? id,
  }) {
    return AppUserDto(
      id: id ?? flatObjectValue.id!,
      name: flatObjectValue.getAttributeValueByAttributeId('name'),
      departmentsWithAccess: flatObjectValue
          .getAttributeValueByAttributeId<List<Object>>('departmentsWithAccess')
          .map((e) => (e as Department).name)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'departmentsWithAccess': departmentsWithAccess,
    };
  }

  factory AppUserDto.fromJson(Map<String, dynamic> map) {
    return AppUserDto(
      id: map['id'] as String,
      name: map['name'] as String,
      departmentsWithAccess: (map['departmentsWithAccess'] as List<dynamic>?)?.cast(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUserDto &&
        other.id == id &&
        other.name == name &&
        listEquals(other.departmentsWithAccess, departmentsWithAccess);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ departmentsWithAccess.hashCode;
}
