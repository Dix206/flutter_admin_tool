import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_time/flat_attribute_time.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeTimeWidget extends StatefulWidget {
  final TimeOfDay? currentValue;
  final FlatAttributeTime flatTypeTime;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<TimeOfDay> onFlatTypeUpdated;

  const FlatAttributeTimeWidget({
    super.key,
    required this.flatTypeTime,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
  });

  @override
  State<FlatAttributeTimeWidget> createState() => _FlatAttributeTimeWidgetState();
}

class _FlatAttributeTimeWidgetState extends State<FlatAttributeTimeWidget> {
  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _selectTime,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.timer),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.flatTypeTime.valueToString(
                      context: context,
                      value: widget.currentValue,
                    ),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (widget.currentValue != null)
                  InkWell(
                    child: const Icon(Icons.close),
                    onTap: () => widget.onFlatTypeUpdated(null),
                  ),
              ],
            ),
          ),
        ),
        if (widget.shouldDisplayValidationErrors && !widget.flatTypeTime.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4,
            ),
            child: Text(
              widget.flatTypeTime.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }

  Future<void> _selectTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: widget.currentValue ?? TimeOfDay.now(),
    );

    if (selectedTime != null) {
      widget.onFlatTypeUpdated(selectedTime);
    }
  }
}
