import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_int/cms_attribut_int.dart';

class CmsAttributIntWidget extends StatefulWidget {
  final BuildContext context;
  final int? currentValue;
  final CmsAttributInt cmsTypeInt;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<int> onCmsTypeUpdated;

  const CmsAttributIntWidget({
    Key? key,
    required this.context,
    required this.cmsTypeInt,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributIntWidget> createState() => _CmsAttributIntWidgetState();
}

class _CmsAttributIntWidgetState extends State<CmsAttributIntWidget> {
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
