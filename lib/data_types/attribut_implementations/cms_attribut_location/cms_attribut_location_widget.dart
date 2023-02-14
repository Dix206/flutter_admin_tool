import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_location/cms_attribut_location.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_location/cms_location.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';

class CmsAttributLocationWidget extends StatefulWidget {
  final BuildContext context;
  final CmsLocation? currentValue;
  final CmsAttributLocation cmsTypeLocation;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<CmsLocation> onCmsTypeUpdated;

  const CmsAttributLocationWidget({
    Key? key,
    required this.context,
    required this.cmsTypeLocation,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributLocationWidget> createState() => _CmsAttributLocationWidgetState();
}

class _CmsAttributLocationWidgetState extends State<CmsAttributLocationWidget> {
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
    widget.onCmsTypeUpdated(
      latitude != null && longitude != null ? CmsLocation(latitude: latitude, longitude: longitude) : null,
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
            hintText: widget.cmsTypeLocation.latitudeHint,
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
            hintText: widget.cmsTypeLocation.longitudeHint,
            border: const OutlineInputBorder(),
          ),
        ),
        if (!widget.cmsTypeLocation.isValid(widget.currentValue) && widget.shouldDisplayValidationErrors)
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16,
              top: 8,
            ),
            child: Text(
              widget.cmsTypeLocation.invalidValueErrorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}