import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cms/data_types/cms_attribut_value.dart';

typedef Validator<T extends Object> = bool Function(T?);
typedef OnCmsTypeUpdated<T extends Object> = void Function(T?);

/// This class represents a single attribute of a [CmsObject].
/// [T] is the type of the value of this attribute.
abstract class CmsAttribut<T extends Object> extends Equatable {
  /// The name of an attribute will be shown in the CMS-UI.
  final String name;
  final bool isOptional;
  final Validator<T>? validator;
  final String? invalidValueErrorMessage;

  const CmsAttribut({
    required this.name,
    required this.invalidValueErrorMessage,
    required this.isOptional,
    required this.validator,
  });

  Widget buildWidget({
    required BuildContext context,
    required T? currentValue,
    required bool shouldDisplayValidationErrors,
    required OnCmsTypeUpdated<T> onCmsTypeUpdated,
  });

  bool isValid(T? value) {
    return  (isOptional && value == null) || (validator?.call(value) ?? true);
  }

  CmsAttributValue toEmptyAttributValue() {
    return CmsAttributValue<T>(
      name: name,
      value: null,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        name,
        isOptional,
        validator,
        invalidValueErrorMessage,
      ];
}
