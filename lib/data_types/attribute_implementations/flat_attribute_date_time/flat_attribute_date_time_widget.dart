import 'package:flutter/material.dart';
import 'package:flat/data_types/attribute_implementations/flat_attribute_date_time/flat_attribute_date_time.dart';
import 'package:flat/data_types/flat_attribute_structure.dart';
import 'package:flat/data_types/flat_texts.dart';
import 'package:flat/flat_app.dart';

class FlatAttributeDateTimeWidget extends StatefulWidget {
  final DateTime? currentValue;
  final FlatAttributeDateTime flatTypeDateTime;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<DateTime> onFlatTypeUpdated;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const FlatAttributeDateTimeWidget({
    Key? key,
    required this.flatTypeDateTime,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
    required this.minDateTime,
    required this.maxDateTime,
  }) : super(key: key);

  @override
  State<FlatAttributeDateTimeWidget> createState() => _FlatAttributeDateTimeWidgetState();
}

class _FlatAttributeDateTimeWidgetState extends State<FlatAttributeDateTimeWidget> {
  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _selectDateTime,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.flatTypeDateTime.valueToString(
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
        if (widget.shouldDisplayValidationErrors && !widget.flatTypeDateTime.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4,
            ),
            child: Text(
              widget.flatTypeDateTime.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }

  Future<void> _selectDateTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.currentValue ?? DateTime.now(),
      firstDate: widget.minDateTime ?? DateTime(1900),
      lastDate: widget.maxDateTime ?? DateTime(2100),
    );
    if (selectedDate == null || !mounted) return;

    // ignore: use_build_context_synchronously
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.currentValue ?? DateTime.now()),
    );
    if (selectedTime != null) {
      widget.onFlatTypeUpdated(
        DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        ),
      );
    }
  }
}
