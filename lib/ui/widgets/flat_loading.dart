import 'package:flutter/material.dart';

class FlatLoading extends StatelessWidget {
  final double size;

  const FlatLoading({
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
