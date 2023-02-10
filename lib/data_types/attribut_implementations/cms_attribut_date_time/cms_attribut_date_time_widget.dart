import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date_time/cms_attribut_date_time.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributDateTimeWidget extends StatefulWidget {
  final BuildContext context;
  final DateTime? currentValue;
  final CmsAttributDateTime cmsTypeDateTime;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<DateTime> onCmsTypeUpdated;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const CmsAttributDateTimeWidget({
    Key? key,
    required this.context,
    required this.cmsTypeDateTime,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
    required this.minDateTime,
    required this.maxDateTime,
  }) : super(key: key);

  @override
  State<CmsAttributDateTimeWidget> createState() => _CmsAttributDateTimeWidgetState();
}

class _CmsAttributDateTimeWidgetState extends State<CmsAttributDateTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _selectDateTime,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 16),
                Text(
                  widget.cmsTypeDateTime.valueToString(
                    context: context,
                    value: widget.currentValue,
                  ),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeDateTime.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              widget.cmsTypeDateTime.invalidValueErrorMessage,
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
      widget.onCmsTypeUpdated(
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
