import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  final String parameter;

  const RegisterScreen({
    Key? key,
    required this.parameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Register Screen!"),
            Text("This is the passed parameter: $parameter"),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text("back to login"),
              onPressed: () => context.go("/login"),
            ),
          ],
        ),
      ),
    );
  }
}
