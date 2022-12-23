import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribut.dart';
import 'package:flutter_cms/data_types/cms_attribut_string.dart';

class CmsAttributStringWidget extends StatefulWidget {
  final BuildContext context;
  final String? currentValue;
  final CmsAttributString cmsTypeString;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<String> onCmsTypeUpdated;

  const CmsAttributStringWidget({
    Key? key,
    required this.context,
    required this.cmsTypeString,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributStringWidget> createState() => _CmsAttributStringWidgetState();
}

class _CmsAttributStringWidgetState extends State<CmsAttributStringWidget> {
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
    final isValid =
        widget.cmsTypeString.isOptional || (widget.cmsTypeString.validator?.call(widget.currentValue) ?? true);

    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        labelText: widget.cmsTypeString.name,
        hintText: widget.cmsTypeString.hint,
        errorText:
            isValid || !widget.shouldDisplayValidationErrors ? null : widget.cmsTypeString.invalidValueErrorMessage,
      ),
    );
  }
}
