import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_color/flat_attribute_color.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_button.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class FlatAttributeColorWidget extends StatelessWidget {
  final Color? currentValue;
  final String title;
  final OnFlatTypeUpdated<Color> onFlatTypeUpdated;
  final bool shouldDisplayValidationErrors;
  final FlatAttributeColor flatAttributeColor;

  const FlatAttributeColorWidget({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.onFlatTypeUpdated,
    required this.shouldDisplayValidationErrors,
    required this.flatAttributeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        flatAttributeColor.valueToString(
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
      subtitle: shouldDisplayValidationErrors && !flatAttributeColor.isValid(currentValue)
          ? Text(
              flatAttributeColor.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            )
          : null,
      trailing: currentValue != null
          ? InkWell(
              child: const Icon(Icons.close),
              onTap: () => onFlatTypeUpdated(null),
            )
          : null,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _ColorPicker(
            onFlatTypeUpdated: onFlatTypeUpdated,
            initialColor: currentValue ?? Colors.black,
          ),
        );
      },
    );
  }
}

class _ColorPicker extends StatefulWidget {
  final OnFlatTypeUpdated<Color> onFlatTypeUpdated;
  final Color initialColor;

  const _ColorPicker({
    Key? key,
    required this.onFlatTypeUpdated,
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
    final flatTexts = FlatApp.getFlatTexts(context);

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
          Text(flatTexts.flatAttributeColorHexTitle),
          const SizedBox(height: 4),
          TextField(
            controller: _hexController,
            decoration: InputDecoration(
              hintText: flatTexts.flatAttributeColorHexTitle,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FlatButton(
            text: flatTexts.select,
            onPressed: () {
              widget.onFlatTypeUpdated(_currentColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
