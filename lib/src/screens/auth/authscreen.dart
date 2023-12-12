import 'package:BuffedUp/const/Captions.dart';
import 'package:BuffedUp/src/services/authService.dart';
import 'package:BuffedUp/src/widget/text.dart';
import 'package:flutter/material.dart';

class auth extends StatefulWidget {
  const auth({super.key});
  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String message = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BigText("Welcome to $title"),
          const SmallText("Be Fit and Track everyting"),
          const SizedBox(
            height: 20,
          ),
          const MediumText("Show Yourself"),
          TextFormField(
              controller: emailController,
              decoration: const InputDecoration(label: Text("Email"))),
          TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(label: Text("Password"))),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  String result = await register(
                      emailController.text, passwordController.text);
                  setState(() {
                    message = result as String;
                  });
                },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: () async {
                  String result = await login(
                      emailController.text, passwordController.text);
                  setState(() {
                    message = result as String;
                  });
                },
                child: const Text("Login"),
              ),
            ],
          ),
          if (message != "") SmallText(message),
        ],
      ),
    ));
  }
}
