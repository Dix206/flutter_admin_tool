import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Function() onLoginSuccess;

  const LoginScreen({
    Key? key,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: "Email",
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              hintText: "Passwort",
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onLoginSuccess,
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
