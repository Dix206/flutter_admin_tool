import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_location/flat_attribute_location.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_location/flat_location.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeLocationWidget extends StatefulWidget {
  final FlatLocation? currentValue;
  final FlatAttributeLocation flatTypeLocation;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<FlatLocation> onFlatTypeUpdated;

  const FlatAttributeLocationWidget({
    super.key,
    required this.flatTypeLocation,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
  });

  @override
  State<FlatAttributeLocationWidget> createState() => _FlatAttributeLocationWidgetState();
}

class _FlatAttributeLocationWidgetState extends State<FlatAttributeLocationWidget> {
  late final _latitudeController = TextEditingController(text: widget.currentValue?.latitude.toString());
  late final _longitudeController = TextEditingController(text: widget.currentValue?.longitude.toString());

  @override
  void initState() {
    _latitudeController.addListener(_setLocation);
    _longitudeController.addListener(_setLocation);
    super.initState();
  }

  void _setLocation() {
    final latitude = double.tryParse(_latitudeController.text.replaceAll(",", "."));
    final longitude = double.tryParse(_longitudeController.text.replaceAll(",", "."));
    widget.onFlatTypeUpdated(
      latitude != null && longitude != null ? FlatLocation(latitude: latitude, longitude: longitude) : null,
    );
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _latitudeController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*")),
          ],
          decoration: InputDecoration(
            hintText: widget.flatTypeLocation.latitudeHint ?? flatTexts.flatAttributeLocationLatitude,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _longitudeController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*")),
          ],
          decoration: InputDecoration(
            hintText: widget.flatTypeLocation.longitudeHint ?? flatTexts.flatAttributeLocationLongitude,
            border: const OutlineInputBorder(),
          ),
        ),
        if (!widget.flatTypeLocation.isValid(widget.currentValue) && widget.shouldDisplayValidationErrors)
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16,
              top: 8,
            ),
            child: Text(
              widget.flatTypeLocation.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}
