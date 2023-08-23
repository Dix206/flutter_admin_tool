import 'package:flutter/material.dart';
import 'package:flutter_admin_tool/flat_app.dart';

class FlatErrorWidget extends StatelessWidget {
  final String errorMessage;
  final Function() onRetry;

  const FlatErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: Text(FlatApp.getFlatTexts(context).errorMessageRetryButton),
          ),
        ],
      ),
    );
  }
}
