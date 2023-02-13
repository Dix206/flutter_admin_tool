import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_date/cms_attribut_date.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributDateWidget extends StatefulWidget {
  final BuildContext context;
  final DateTime? currentValue;
  final CmsAttributDate cmsTypeDate;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<DateTime> onCmsTypeUpdated;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const CmsAttributDateWidget({
    Key? key,
    required this.context,
    required this.cmsTypeDate,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
    required this.minDateTime,
    required this.maxDateTime,
  }) : super(key: key);

  @override
  State<CmsAttributDateWidget> createState() => _CmsAttributDateWidgetState();
}

class _CmsAttributDateWidgetState extends State<CmsAttributDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _selectDate,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 16),
                Text(
                  widget.cmsTypeDate.valueToString(
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
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeDate.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4,
            ),
            child: Text(
              widget.cmsTypeDate.invalidValueErrorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.currentValue ?? DateTime.now(),
      firstDate: widget.minDateTime ?? DateTime(1900),
      lastDate: widget.maxDateTime ?? DateTime(2100),
    );
    if (selectedDate == null || !mounted) return;

    widget.onCmsTypeUpdated(selectedDate);
  }
}
