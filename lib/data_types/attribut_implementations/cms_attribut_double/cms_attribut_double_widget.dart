import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_double/cms_attribut_double.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributDoubleWidget extends StatefulWidget {
  final BuildContext context;
  final double? currentValue;
  final CmsAttributDouble cmsTypeDouble;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<double> onCmsTypeUpdated;

  const CmsAttributDoubleWidget({
    Key? key,
    required this.context,
    required this.cmsTypeDouble,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributDoubleWidget> createState() => _CmsAttributDoubleWidgetState();
}

class _CmsAttributDoubleWidgetState extends State<CmsAttributDoubleWidget> {
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
        // a FilteringTextInputFormatter which only allows input for double values
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
