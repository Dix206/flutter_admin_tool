import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';

class FlatAttributeBoolWidget extends StatelessWidget {
  final bool currentValue;
  final String title;
  final OnFlatTypeUpdated<bool> onFlatTypeUpdated;

  const FlatAttributeBoolWidget({
    super.key,
    required this.title,
    required this.currentValue,
    required this.onFlatTypeUpdated,
  });

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
