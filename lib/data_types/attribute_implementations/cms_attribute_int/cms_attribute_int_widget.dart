import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_int/cms_attribute_int.dart';

class CmsAttributeIntWidget extends StatefulWidget {
  final int? currentValue;
  final CmsAttributeInt cmsTypeInt;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<int> onCmsTypeUpdated;

  const CmsAttributeIntWidget({
    Key? key,
    required this.cmsTypeInt,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributeIntWidget> createState() => _CmsAttributeIntWidgetState();
}

class _CmsAttributeIntWidgetState extends State<CmsAttributeIntWidget> {
  late final _textEditingController = TextEditingController(text: widget.currentValue?.toString());

  @override
  void initState() {
    _textEditingController.addListener(
      () => widget.onCmsTypeUpdated(int.tryParse(_textEditingController.text)),
    );
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: widget.cmsTypeInt.hint,
        border: const OutlineInputBorder(),
        errorText: widget.cmsTypeInt.isValid(widget.currentValue) || !widget.shouldDisplayValidationErrors
            ? null
            : widget.cmsTypeInt.invalidValueErrorMessage,
      ),
    );
  }
}
