import 'package:example/appwrite/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLoginSuccess;

  const LoginScreen({
    Key? key,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController(text: "bb@test.de");
  final passwordController = TextEditingController(text: "123456789");

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: "Passwort",
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              final result = await authAppwriteService.login(
                email: emailController.text,
                password: passwordController.text,
              );

              result.fold(
                onError: (error) => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(error),
                  ),
                ),
                onSuccess: (_) => widget.onLoginSuccess(),
              );
            },
            child: const Text("Login"),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            child: const Text("Register"),
            onPressed: () => context.go("/register/LoginParameter"),
          ),
        ],
      ),
    );
  }
}
