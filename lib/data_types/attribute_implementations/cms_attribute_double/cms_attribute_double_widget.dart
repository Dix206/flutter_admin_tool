import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_double/cms_attribute_double.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';

class CmsAttributeDoubleWidget extends StatefulWidget {
  final double? currentValue;
  final CmsAttributeDouble cmsTypeDouble;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<double> onCmsTypeUpdated;

  const CmsAttributeDoubleWidget({
    Key? key,
    required this.cmsTypeDouble,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributeDoubleWidget> createState() => _CmsAttributeDoubleWidgetState();
}

class _CmsAttributeDoubleWidgetState extends State<CmsAttributeDoubleWidget> {
  late final _textEditingController = TextEditingController(text: widget.currentValue?.toString());

  @override
  void initState() {
    _textEditingController.addListener(
      () => widget.onCmsTypeUpdated(
        double.tryParse(_textEditingController.text.replaceAll(",", ".")),
      ),
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
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*")),
      ],
      decoration: InputDecoration(
        hintText: widget.cmsTypeDouble.hint,
        border: const OutlineInputBorder(),
        errorText: widget.cmsTypeDouble.isValid(widget.currentValue) || !widget.shouldDisplayValidationErrors
            ? null
            : widget.cmsTypeDouble.invalidValueErrorMessage,
      ),
    );
  }
}
