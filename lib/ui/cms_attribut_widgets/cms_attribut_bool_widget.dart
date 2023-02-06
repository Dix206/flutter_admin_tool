import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_bool.dart';
import 'package:flutter_cms/data_types/cms_attribut.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_int.dart';

class CmsAttributBoolWidget extends StatelessWidget {
  final bool currentValue;
  final String title;
  final OnCmsTypeUpdated<bool> onCmsTypeUpdated;

  const CmsAttributBoolWidget({
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
      title: Text(title),
    );
  }
}
