import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_string/cms_attribute_string.dart';

class CmsAttributeStringWidget extends StatefulWidget {
  final String? currentValue;
  final CmsAttributeString cmsTypeString;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<String> onCmsTypeUpdated;
  final int? maxLength;

  const CmsAttributeStringWidget({
    Key? key,
    required this.cmsTypeString,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
    required this.maxLength,
  }) : super(key: key);

  @override
  State<CmsAttributeStringWidget> createState() => _CmsAttributeStringWidgetState();
}

class _CmsAttributeStringWidgetState extends State<CmsAttributeStringWidget> {
  late final _textEditingController = TextEditingController(text: widget.currentValue);

  @override
  void initState() {
    _textEditingController.addListener(
      () => widget.onCmsTypeUpdated(_textEditingController.text),
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
    final isValid = widget.cmsTypeString.isValid(widget.currentValue);

    return TextField(
      controller: _textEditingController,
      maxLines: widget.cmsTypeString.isMultiline ? 10 : 1,
      minLines: widget.cmsTypeString.isMultiline ? 3 : 1,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        hintText: widget.cmsTypeString.hint,
        border: const OutlineInputBorder(),
        errorText:
            isValid || !widget.shouldDisplayValidationErrors ? null : widget.cmsTypeString.invalidValueErrorMessage,
      ),
    );
  }
}
