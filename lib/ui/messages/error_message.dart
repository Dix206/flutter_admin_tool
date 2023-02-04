import 'package:flutter/material.dart';

void showErrorMessage({
  required BuildContext context,
  required String errorMessage,
}) {
  final snackBar = SnackBar(
    content: Text(
      errorMessage,
      style: Theme.of(context)
          .textTheme
          .displayMedium
          ?.copyWith(color: Theme.of(context).colorScheme.onError),
    ),
    backgroundColor: Theme.of(context).colorScheme.error,
    padding: const EdgeInsets.all(16),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
