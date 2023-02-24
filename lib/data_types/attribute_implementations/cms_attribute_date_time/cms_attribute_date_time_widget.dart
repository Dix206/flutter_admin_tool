import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_date_time/cms_attribute_date_time.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeDateTimeWidget extends StatefulWidget {
  final DateTime? currentValue;
  final CmsAttributeDateTime cmsTypeDateTime;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<DateTime> onCmsTypeUpdated;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const CmsAttributeDateTimeWidget({
    Key? key,
    required this.cmsTypeDateTime,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
    required this.minDateTime,
    required this.maxDateTime,
  }) : super(key: key);

  @override
  State<CmsAttributeDateTimeWidget> createState() => _CmsAttributeDateTimeWidgetState();
}

class _CmsAttributeDateTimeWidgetState extends State<CmsAttributeDateTimeWidget> {
  @override
  Widget build(BuildContext context) {
    final CmsTexts cmsTexts = FlutterCms.getCmsTexts(context);

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
                    widget.cmsTypeDateTime.valueToString(
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
                    onTap: () => widget.onCmsTypeUpdated(null),
                  ),
              ],
            ),
          ),
        ),
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeDateTime.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4,
            ),
            child: Text(
              widget.cmsTypeDateTime.invalidValueErrorMessage ?? cmsTexts.defaultInvalidDataMessage,
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
