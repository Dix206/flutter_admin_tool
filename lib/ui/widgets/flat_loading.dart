import 'package:flutter/material.dart';

class FlatLoading extends StatelessWidget {
  final double size;

  const FlatLoading({
    super.key,
    this.size = 24.0,
  });

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
