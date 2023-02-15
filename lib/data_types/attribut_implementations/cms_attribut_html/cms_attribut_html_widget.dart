import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cms/data_types/attribut_implementations/cms_attribut_html/cms_attribut_html.dart';
import 'package:flutter_cms/data_types/cms_attribut_structure.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class CmsAttributHtmlWidget extends StatefulWidget {
  final String? currentValue;
  final CmsAttributHtml cmsTypeHtml;
  final bool shouldDisplayValidationErrors;
  final OnCmsTypeUpdated<String> onCmsTypeUpdated;

  const CmsAttributHtmlWidget({
    Key? key,
    required this.cmsTypeHtml,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onCmsTypeUpdated,
  }) : super(key: key);

  @override
  State<CmsAttributHtmlWidget> createState() => _CmsAttributHtmlWidgetState();
}

class _CmsAttributHtmlWidgetState extends State<CmsAttributHtmlWidget> {
  final controller = QuillEditorController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          hintText: 'Hint text goes here',
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
              widget.cmsTypeHtml.invalidValueErrorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
