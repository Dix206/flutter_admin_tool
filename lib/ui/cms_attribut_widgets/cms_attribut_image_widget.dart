import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribut.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image.dart';

class CmsAttributImageWidget extends StatefulWidget {
  final BuildContext context;
  final ImageValue? currentValue;
  final CmsAttributImage cmsTypeString;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<ImageValue> onCmsTypeUpdated;

  const CmsAttributImageWidget({
    Key? key,
    required this.context,
    required this.cmsTypeString,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributImageWidget> createState() => _CmsAttributImageWidgetState();
}

class _CmsAttributImageWidgetState extends State<CmsAttributImageWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );

        if (result?.files.first.bytes != null) {
          final bytes = result!.files.first.bytes!;
          widget.onCmsTypeUpdated(
            ImageValue(
              imageData: bytes,
              imageUrl: widget.currentValue?.imageUrl,
              headers: widget.currentValue?.headers,
            ),
          );
        }
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget.currentValue?.imageData != null
            ? Image.memory(
                widget.currentValue!.imageData!,
                fit: BoxFit.cover,
              )
            : widget.currentValue?.imageUrl != null
                ? Image.network(
                    widget.currentValue!.imageUrl!,
                    fit: BoxFit.cover,
                    headers: widget.currentValue?.headers,
                  )
                : const Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
      ),
    );
  }
}
