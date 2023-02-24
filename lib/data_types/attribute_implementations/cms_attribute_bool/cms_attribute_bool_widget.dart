import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';

class CmsAttributeBoolWidget extends StatelessWidget {
  final bool currentValue;
  final String title;
  final OnCmsTypeUpdated<bool> onCmsTypeUpdated;

  const CmsAttributeBoolWidget({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: currentValue,
      onChanged: onCmsTypeUpdated,
      contentPadding: EdgeInsets.zero,
      title: Text(title),
    );
  }
}
