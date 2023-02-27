import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flat/data_types/attribute_implementations/flat_attribute_html/flat_attribute_html.dart';
import 'package:flat/data_types/flat_attribute_structure.dart';
import 'package:flat/data_types/flat_texts.dart';
import 'package:flat/flat_app.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class FlatAttributeHtmlWidget extends StatefulWidget {
  final String? currentValue;
  final FlatAttributeHtml flatTypeHtml;
  final bool shouldDisplayValidationErrors;
  final OnFlatTypeUpdated<String> onFlatTypeUpdated;

  const FlatAttributeHtmlWidget({
    Key? key,
    required this.flatTypeHtml,
    required this.currentValue,
    required this.shouldDisplayValidationErrors,
    required this.onFlatTypeUpdated,
  }) : super(key: key);

  @override
  State<FlatAttributeHtmlWidget> createState() => _FlatAttributeHtmlWidgetState();
}

class _FlatAttributeHtmlWidgetState extends State<FlatAttributeHtmlWidget> {
  final controller = QuillEditorController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FlatTexts flatTexts = FlatApp.getFlatTexts(context);
    
    if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      return const Center(
        child: Text('Not supported on this platform'),
      );
    }

    final isValid = widget.flatTypeHtml.isValid(widget.currentValue);

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
          onTextChanged: widget.onFlatTypeUpdated,
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
              widget.flatTypeHtml.invalidValueErrorMessage ?? flatTexts.defaultInvalidDataMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
      ],
    );
  }
}
