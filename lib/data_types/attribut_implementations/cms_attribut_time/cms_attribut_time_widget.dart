import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_time/cms_attribut_time.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributTimeWidget extends StatefulWidget {
  final BuildContext context;
  final TimeOfDay? currentValue;
  final CmsAttributTime cmsTypeTime;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<TimeOfDay> onCmsTypeUpdated;

  const CmsAttributTimeWidget({
    Key? key,
    required this.context,
    required this.cmsTypeTime,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributTimeWidget> createState() => _CmsAttributTimeWidgetState();
}

class _CmsAttributTimeWidgetState extends State<CmsAttributTimeWidget> {
  @override
  Widget build(BuildContext context) {
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
                Text(
                  widget.cmsTypeTime.valueToString(
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
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeTime.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4,
            ),
            child: Text(
              widget.cmsTypeTime.invalidValueErrorMessage,
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
