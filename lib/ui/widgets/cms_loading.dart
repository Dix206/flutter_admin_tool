import 'package:flutter/material.dart';

class CmsLoading extends StatelessWidget {
  final double size;

  const CmsLoading({
    Key? key,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
