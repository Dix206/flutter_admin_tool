import 'package:flutter/material.dart';

class CmsButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
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
          color: isLoading ? Colors.grey : buttonColor ?? Theme.of(context).primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isLoading ? Colors.grey : textColor ?? Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: isLoading ? Colors.black : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
