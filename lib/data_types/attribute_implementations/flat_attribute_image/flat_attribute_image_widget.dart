import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_image/flat_attribute_image.dart';
import 'package:flutter_admin_tool/data_types/flat_file_value.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';
import 'package:flutter_admin_tool/ui/widgets/flat_button.dart';

class FlatAttributeImageWidget extends StatefulWidget {
  final FlatFileValue? currentValue;
  final FlatAttributeImage flatTypeImage;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<FlatFileValue> onFlatTypeUpdated;

  const FlatAttributeImageWidget({
    super.key,
    required this.flatTypeImage,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
  });

  @override
  State<FlatAttributeImageWidget> createState() => _FlatAttributeImageWidgetState();
}

class _FlatAttributeImageWidgetState extends State<FlatAttributeImageWidget> {
  static const _imageSize = 100.0;

  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

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

              widget.onFlatTypeUpdated(
                FlatFileValue(
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
            child: FlatButton(
              onPressed: () => widget.onFlatTypeUpdated(
                FlatFileValue(
                  data: null,
                  wasDeleted: true,
                  fileName: widget.currentValue?.fileName,
                  url: widget.currentValue?.url,
                  authHeaders: widget.currentValue?.authHeaders,
                ),
              ),
              text: FlatApp.getFlatTexts(context).delete,
              buttonColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        ],
        if (widget.shouldDisplayValidationErrors && !widget.flatTypeImage.isValid(widget.currentValue)) ...[
          const SizedBox(height: 8),
          Text(
            widget.flatTypeImage.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ],
      ],
    );
  }
}
