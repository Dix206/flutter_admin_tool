import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_date/cms_attribute_date.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeDateWidget extends StatefulWidget {
  final DateTime? currentValue;
  final CmsAttributeDate cmsTypeDate;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<DateTime> onCmsTypeUpdated;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;

  const CmsAttributeDateWidget({
    Key? key,
    required this.cmsTypeDate,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
    required this.minDateTime,
    required this.maxDateTime,
  }) : super(key: key);

  @override
  State<CmsAttributeDateWidget> createState() => _CmsAttributeDateWidgetState();
}

class _CmsAttributeDateWidgetState extends State<CmsAttributeDateWidget> {
  @override
  Widget build(BuildContext context) {
    final CmsTexts cmsTexts = FlutterCms.getCmsTexts(context);

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
                Expanded(
                  child: Text(
                    widget.cmsTypeDate.valueToString(
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
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeDate.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4,
            ),
            child: Text(
              widget.cmsTypeDate.invalidValueErrorMessage ?? cmsTexts.defaultInvalidDataMessage,
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
