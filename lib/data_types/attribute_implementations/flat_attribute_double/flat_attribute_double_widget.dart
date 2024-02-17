import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_double/flat_attribute_double.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';

class FlatAttributeDoubleWidget extends StatefulWidget {
  final double? currentValue;
  final FlatAttributeDouble flatTypeDouble;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<double> onFlatTypeUpdated;

  const FlatAttributeDoubleWidget({
    super.key,
    required this.flatTypeDouble,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
  });

  @override
  State<FlatAttributeDoubleWidget> createState() => _FlatAttributeDoubleWidgetState();
}

class _FlatAttributeDoubleWidgetState extends State<FlatAttributeDoubleWidget> {
  late final _textEditingController = TextEditingController(text: widget.currentValue?.toString());

  @override
  void initState() {
    _textEditingController.addListener(
      () => widget.onFlatTypeUpdated(
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
        hintText: widget.flatTypeDouble.hint,
        border: const OutlineInputBorder(),
        errorText: widget.flatTypeDouble.isValid(widget.currentValue) || !widget.shouldDisplayValidationErrors
            ? null
            : widget.flatTypeDouble.invalidValueErrorMessage,
      ),
    );
  }
}
