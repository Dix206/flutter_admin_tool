import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';

class FlatAttributeBoolWidget extends StatelessWidget {
  final bool currentValue;
  final String title;
  final OnFlatTypeUpdated<bool> onFlatTypeUpdated;

  const FlatAttributeBoolWidget({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.onFlatTypeUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: currentValue,
      onChanged: onFlatTypeUpdated,
      contentPadding: EdgeInsets.zero,
      title: Text(title),
    );
  }
}
