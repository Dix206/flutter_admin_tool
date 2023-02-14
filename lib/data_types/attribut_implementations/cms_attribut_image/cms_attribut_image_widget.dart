import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_image/cms_attribut_image.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';

class CmsAttributImageWidget extends StatefulWidget {
  final ImageValue? currentValue;
  final CmsAttributImage cmsTypeString;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<ImageValue> onCmsTypeUpdated;

  const CmsAttributImageWidget({
    Key? key,
    required this.cmsTypeString,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributImageWidget> createState() => _CmsAttributImageWidgetState();
}

class _CmsAttributImageWidgetState extends State<CmsAttributImageWidget> {
  static const _imageSize = 100.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.image,
            );

            if (result?.files.first.bytes != null) {
              final bytes = result!.files.first.bytes!;
              widget.onCmsTypeUpdated(
                ImageValue(
                  imageData: bytes,
                  wasDeleted: false,
                  imageUrl: widget.currentValue?.imageUrl,
                  headers: widget.currentValue?.headers,
                ),
              );
            }
          },
          child: Container(
            height: _imageSize,
            width: _imageSize,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.currentValue?.imageData != null
                  ? Image.memory(
                      widget.currentValue!.imageData!,
                      fit: BoxFit.cover,
                    )
                  : widget.currentValue?.imageUrl != null && !widget.currentValue!.wasDeleted
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
          ),
        ),
        if (widget.currentValue != null &&
            (widget.currentValue!.imageData != null ||
                (widget.currentValue!.imageUrl != null && !widget.currentValue!.wasDeleted))) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: _imageSize,
            child: CmsButton(
              onPressed: () => widget.onCmsTypeUpdated(
                ImageValue(
                  imageData: null,
                  wasDeleted: true,
                  imageUrl: widget.currentValue?.imageUrl,
                  headers: widget.currentValue?.headers,
                ),
              ),
              text: "Delete",
              buttonColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        ],
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeString.isValid(widget.currentValue)) ...[
          const SizedBox(height: 8),
          Text(
            widget.cmsTypeString.invalidValueErrorMessage,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ],
      ],
    );
  }
}
