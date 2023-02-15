import 'package:flutter/material.dart';
import 'package:flutter_cms/flutter_cms.dart';

void showErrorMessage({
  required BuildContext context,
  required String errorMessage,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(FlutterCms.getCmsTexts(context).errorMessageTitle),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(FlutterCms.getCmsTexts(context).ok),
        ),
      ],
    ),
  );
}
