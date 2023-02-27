import 'package:flutter/material.dart';
import 'package:flat/data_types/flat_attribute_structure.dart';
import 'package:flat/data_types/attribute_implementations/flat_attribute_string/flat_attribute_string.dart';

class FlatAttributeStringWidget extends StatefulWidget {
  final String? currentValue;
  final FlatAttributeString flatTypeString;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<String> onFlatTypeUpdated;
  final int? maxLength;

  const FlatAttributeStringWidget({
    Key? key,
    required this.flatTypeString,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
    required this.maxLength,
  }) : super(key: key);

  @override
  State<FlatAttributeStringWidget> createState() => _FlatAttributeStringWidgetState();
}

class _FlatAttributeStringWidgetState extends State<FlatAttributeStringWidget> {
  late final _textEditingController = TextEditingController(text: widget.currentValue);

  @override
  void initState() {
    _textEditingController.addListener(
      () => widget.onFlatTypeUpdated(_textEditingController.text),
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
    final isValid = widget.flatTypeString.isValid(widget.currentValue);

    return TextField(
      controller: _textEditingController,
      maxLines: widget.flatTypeString.isMultiline ? 10 : 1,
      minLines: widget.flatTypeString.isMultiline ? 3 : 1,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        hintText: widget.flatTypeString.hint,
        border: const OutlineInputBorder(),
        errorText:
            isValid || !widget.shouldDisplayValidationErrors ? null : widget.flatTypeString.invalidValueErrorMessage,
      ),
    );
  }
}
