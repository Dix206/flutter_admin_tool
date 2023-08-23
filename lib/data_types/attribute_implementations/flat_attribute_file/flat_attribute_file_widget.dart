import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/data_types/attribute_implementations/flat_attribute_file/flat_attribute_file.dart';
import 'package:flutter_admin_tool/data_types/flat_attribute_structure.dart';
import 'package:flutter_admin_tool/data_types/flat_file_value.dart';
import 'package:flutter_admin_tool/data_types/flat_texts.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatAttributeFileWidget extends StatefulWidget {
  final FlatFileValue? currentValue;
  final FlatAttributeFile flatTypeFile;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<FlatFileValue> onFlatTypeUpdated;

  const FlatAttributeFileWidget({
    Key? key,
    required this.flatTypeFile,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
  }) : super(key: key);

  @override
  State<FlatAttributeFileWidget> createState() => _FlatAttributeFileWidgetState();
}

class _FlatAttributeFileWidgetState extends State<FlatAttributeFileWidget> {
  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles();

            if (result?.files.first.bytes != null) {
              final bytes = result!.files.first.bytes!;
              final path = result.files.first.name;

              widget.onFlatTypeUpdated(
                FlatFileValue(
                  data: bytes,
                  fileName: path,
                  wasDeleted: false,
                  url: widget.currentValue?.url,
                  authHeaders: widget.currentValue?.authHeaders,
                ),
              );
            }
          },
          title: Text(
            widget.currentValue?.fileName ??
                (widget.currentValue?.wasDeleted != true && widget.currentValue?.url != null
                    ? widget.currentValue!.url!
                    : FlatApp.getFlatTexts(context).flatAttributeFileSelectFileMessage),
          ),
          leading: widget.currentValue?.data == null &&
                  widget.currentValue?.url != null &&
                  widget.currentValue?.wasDeleted == false &&
                  widget.flatTypeFile.onFileDownload != null
              ? IconButton(
                  onPressed: () => widget.flatTypeFile.onFileDownload!.call(widget.currentValue!.url!),
                  icon: const Icon(Icons.file_download),
                )
              : null,
          trailing: widget.currentValue != null &&
                  (widget.currentValue!.data != null ||
                      (widget.currentValue!.url != null && !widget.currentValue!.wasDeleted))
              ? IconButton(
                  onPressed: () => widget.onFlatTypeUpdated(
                    FlatFileValue(
                      data: null,
                      fileName: null,
                      wasDeleted: true,
                      url: widget.currentValue?.url,
                      authHeaders: widget.currentValue?.authHeaders,
                    ),
                  ),
                  icon: const Icon(Icons.delete),
                )
              : null,
        ),
        if (widget.shouldDisplayValidationErrors && !widget.flatTypeFile.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16,
              right: 16,
            ),
            child: Text(
              widget.flatTypeFile.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
