import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribute_implementations/cms_attribute_html/cms_attribute_html.dart';
import 'package:flutter_cms/data_types/cms_attribute_structure.dart';
import 'package:flutter_cms/data_types/cms_texts.dart';
import 'package:flutter_cms/flutter_cms.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class CmsAttributeHtmlWidget extends StatefulWidget {
  final String? currentValue;
  final CmsAttributeHtml cmsTypeHtml;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<String> onCmsTypeUpdated;

  const CmsAttributeHtmlWidget({
    Key? key,
    required this.cmsTypeHtml,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributeHtmlWidget> createState() => _CmsAttributeHtmlWidgetState();
}

class _CmsAttributeHtmlWidgetState extends State<CmsAttributeHtmlWidget> {
  final controller = QuillEditorController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CmsTexts cmsTexts = FlutterCms.getCmsTexts(context);
    
    if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      return const Center(
        child: Text('Not supported on this platform'),
      );
    }

    final isValid = widget.cmsTypeHtml.isValid(widget.currentValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToolBar(
          toolBarColor: Theme.of(context).colorScheme.primaryContainer,
          activeIconColor: Theme.of(context).colorScheme.onPrimaryContainer,
          iconColor: Theme.of(context).colorScheme.inversePrimary,
          padding: const EdgeInsets.all(8),
          iconSize: 20,
          controller: controller,
          toolBarConfig: List.of(ToolBarStyle.values)
            ..remove(ToolBarStyle.video)
            ..remove(ToolBarStyle.clean)
            ..remove(ToolBarStyle.indentAdd)
            ..remove(ToolBarStyle.indentMinus)
            ..remove(ToolBarStyle.headerOne)
            ..remove(ToolBarStyle.headerTwo)
            ..remove(ToolBarStyle.strike),
        ),
        QuillHtmlEditor(
          controller: controller,
          height: 400,
          text: widget.currentValue,
          onTextChanged: widget.onCmsTypeUpdated,
          defaultFontColor: Theme.of(context).colorScheme.onBackground,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        if (!isValid && widget.shouldDisplayValidationErrors)
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              widget.cmsTypeHtml.invalidValueErrorMessage ?? cmsTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}