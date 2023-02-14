import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_file/cms_attribut_file.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';

class CmsAttributFileWidget extends StatefulWidget {
  final CmsFileValue? currentValue;
  final CmsAttributFile cmsTypeFile;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<CmsFileValue> onCmsTypeUpdated;

  const CmsAttributFileWidget({
    Key? key,
    required this.cmsTypeFile,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributFileWidget> createState() => _CmsAttributFileWidgetState();
}

class _CmsAttributFileWidgetState extends State<CmsAttributFileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles();

            if (result?.files.first.bytes != null) {
              final bytes = result!.files.first.bytes!;
              final path = result.files.first.name;

              widget.onCmsTypeUpdated(
                CmsFileValue(
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
                    : "Select a file"),
          ),
          leading: widget.currentValue?.data == null &&
                  widget.currentValue?.url != null &&
                  widget.currentValue?.wasDeleted == false &&
                  widget.cmsTypeFile.onFileDownload != null
              ? IconButton(
                  onPressed: () => widget.cmsTypeFile.onFileDownload!.call(widget.currentValue!.url!),
                  icon: const Icon(Icons.file_download),
                )
              : null,
          trailing: widget.currentValue != null &&
                  (widget.currentValue!.data != null ||
                      (widget.currentValue!.url != null && !widget.currentValue!.wasDeleted))
              ? IconButton(
                  onPressed: () => widget.onCmsTypeUpdated(
                    CmsFileValue(
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
        if (widget.shouldDisplayValidationErrors && !widget.cmsTypeFile.isValid(widget.currentValue))
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16,
              right: 16,
            ),
            child: Text(
              widget.cmsTypeFile.invalidValueErrorMessage,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
