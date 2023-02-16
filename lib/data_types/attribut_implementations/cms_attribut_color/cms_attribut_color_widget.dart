import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_color/cms_attribut_color.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CmsAttributColorWidget extends StatelessWidget {
  final Color? currentValue;
  final String title;
  final OnCmsTypeUpdated<Color> onCmsTypeUpdated;
  final bool shouldDisplayValidationErrors;
  final CmsAttributColor cmsAttributColor;

  const CmsAttributColorWidget({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.onCmsTypeUpdated,
    required this.shouldDisplayValidationErrors,
    required this.cmsAttributColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CmsTexts cmsTexts = FlutterCms.getCmsTexts(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        cmsAttributColor.valueToString(
          context: context,
          value: currentValue,
        ),
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: currentValue,
          border: Border.all(color: currentValue ?? Theme.of(context).colorScheme.onSurface),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      subtitle: shouldDisplayValidationErrors && !cmsAttributColor.isValid(currentValue)
          ? Text(
              cmsAttributColor.invalidValueErrorMessage ?? cmsTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            )
          : null,
      trailing: currentValue != null
          ? InkWell(
              child: const Icon(Icons.close),
              onTap: () => onCmsTypeUpdated(null),
            )
          : null,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _ColorPicker(
            onCmsTypeUpdated: onCmsTypeUpdated,
            initialColor: currentValue ?? Colors.black,
          ),
        );
      },
    );
  }
}

class _ColorPicker extends StatefulWidget {
  final OnCmsTypeUpdated<Color> onCmsTypeUpdated;
  final Color initialColor;

  const _ColorPicker({
    Key? key,
    required this.onCmsTypeUpdated,
    required this.initialColor,
  }) : super(key: key);

  @override
  State<_ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<_ColorPicker> {
  late Color _currentColor = widget.initialColor;

  late final _hexController = TextEditingController(
    text: "#${widget.initialColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}",
  );

  @override
  void initState() {
    _hexController.addListener(() {
      final hex = _hexController.text;
      if (hex.length == 9 && hex.startsWith('#')) {
        final value = int.tryParse(hex.substring(1), radix: 16);
        if (value == null) return;
        final color = Color(value);
        setState(() => _currentColor = color);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cmsTexts = FlutterCms.getCmsTexts(context);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _currentColor,
                onColorChanged: (color) => setState(
                  () {
                    _currentColor = color;
                    _hexController.text = "#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}";
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(cmsTexts.cmsAttributColorHexTitle),
          const SizedBox(height: 4),
          TextField(
            controller: _hexController,
            decoration: InputDecoration(
              hintText: cmsTexts.cmsAttributColorHexTitle,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          CmsButton(
            text: cmsTexts.select,
            onPressed: () {
              widget.onCmsTypeUpdated(_currentColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
