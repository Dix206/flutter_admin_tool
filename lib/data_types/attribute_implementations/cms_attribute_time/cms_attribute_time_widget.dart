import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_time/cms_attribute_time.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/flutter_cms.dart';

class CmsAttributeTimeWidget extends StatefulWidget {
  final TimeOfDay? currentValue;
  final CmsAttributeTime cmsTypeTime;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<TimeOfDay> onCmsTypeUpdated;

  const CmsAttributeTimeWidget({
    Key? key,
    required this.cmsTypeTime,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributeTimeWidget> createState() => _CmsAttributeTimeWidgetState();
}

class _CmsAttributeTimeWidgetState extends State<CmsAttributeTimeWidget> {
  @override
  Widget build(BuildContext context) {
    final CmsTexts cmsTexts = FlutterCms.getCmsTexts(context);

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
                    widget.cmsTypeTime.valueToString(
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
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeTime.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4,
            ),
            child: Text(
              widget.cmsTypeTime.invalidValueErrorMessage ?? cmsTexts.defaultInvalidDataMessage,
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
      widget.onCmsTypeUpdated(selectedTime);
    }
  }
}
