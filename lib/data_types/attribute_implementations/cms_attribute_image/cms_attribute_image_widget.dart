import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_image/cms_attribute_image.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:flutter_cms/ui/widgets/cms_button.dart';

class CmsAttributeImageWidget extends StatefulWidget {
  final CmsFileValue? currentValue;
  final CmsAttributeImage cmsTypeImage;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<CmsFileValue> onCmsTypeUpdated;

  const CmsAttributeImageWidget({
    Key? key,
    required this.cmsTypeImage,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributeImageWidget> createState() => _CmsAttributeImageWidgetState();
}

class _CmsAttributeImageWidgetState extends State<CmsAttributeImageWidget> {
  static const _imageSize = 100.0;

  @override
  Widget build(BuildContext context) {
    final CmsTexts cmsTexts = FlutterCms.getCmsTexts(context);
    
    return Column(
      children: [
        InkWell(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.image,
            );

            if (result?.files.first.bytes != null) {
              final bytes = result!.files.first.bytes!;
              final name = result.files.first.name;

              widget.onCmsTypeUpdated(
                CmsFileValue(
                  data: bytes,
                  wasDeleted: false,
                  fileName: name,
                  url: widget.currentValue?.url,
                  authHeaders: widget.currentValue?.authHeaders,
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
              child: widget.currentValue?.data != null
                  ? Image.memory(
                      widget.currentValue!.data!,
                      fit: BoxFit.cover,
                    )
                  : widget.currentValue?.url != null && !widget.currentValue!.wasDeleted
                      ? Image.network(
                          widget.currentValue!.url!,
                          fit: BoxFit.cover,
                          headers: widget.currentValue?.authHeaders,
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
            (widget.currentValue!.data != null ||
                (widget.currentValue!.url != null && !widget.currentValue!.wasDeleted))) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: _imageSize,
            child: CmsButton(
              onPressed: () => widget.onCmsTypeUpdated(
                CmsFileValue(
                  data: null,
                  wasDeleted: true,
                  fileName: widget.currentValue?.fileName,
                  url: widget.currentValue?.url,
                  authHeaders: widget.currentValue?.authHeaders,
                ),
              ),
              text: FlutterCms.getCmsTexts(context).delete,
              buttonColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        ],
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeImage.isValid(widget.currentValue)) ...[
          const SizedBox(height: 8),
          Text(
            widget.cmsTypeImage.invalidValueErrorMessage ?? cmsTexts.defaultInvalidDataMessage,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ],
      ],
    );
  }
}
