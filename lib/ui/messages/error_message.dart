import 'package:flutter/material.dart';
import 'package:flat/flat_app.dart';

void showErrorMessage({
  required BuildContext context,
  required String errorMessage,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(FlatApp.getFlatTexts(context).errorMessageTitle),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(FlatApp.getFlatTexts(context).ok),
        ),
      ],
    ),
  );
}
