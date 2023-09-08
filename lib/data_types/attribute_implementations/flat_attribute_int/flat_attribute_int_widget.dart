import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_int/flat_attribute_int.dart';

class FlatAttributeIntWidget extends StatefulWidget {
  final int? currentValue;
  final FlatAttributeInt flatTypeInt;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<int> onFlatTypeUpdated;

  const FlatAttributeIntWidget({
    Key? key,
    required this.flatTypeInt,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
  }) : super(key: key);

  @override
  State<FlatAttributeIntWidget> createState() => _FlatAttributeIntWidgetState();
}

class _FlatAttributeIntWidgetState extends State<FlatAttributeIntWidget> {
  late final _textEditingController =
      TextEditingController(text: widget.currentValue?.toString());

  @override
  void initState() {
    _textEditingController.addListener(
      () => widget.onFlatTypeUpdated(int.tryParse(_textEditingController.text)),
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
        hintText: widget.flatTypeInt.hint,
        border: const OutlineInputBorder(),
        errorText: widget.flatTypeInt.isValid(widget.currentValue) ||
                !widget.shouldDisplayValidationErrors
            ? null
            : widget.flatTypeInt.invalidValueErrorMessage,
      ),
    );
  }
}
