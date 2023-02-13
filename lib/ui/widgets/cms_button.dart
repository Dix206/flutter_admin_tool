import 'package:flutter/material.dart';

class CmsButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? buttonColor;
  final Color? textColor;

  const CmsButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isLoading || onPressed == null ? Colors.grey : buttonColor ?? Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              onPressed == null ? Colors.black : textColor ?? Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}
