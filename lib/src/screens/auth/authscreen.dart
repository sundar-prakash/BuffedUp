import 'package:BuffedUp/const/Captions.dart';
import 'package:BuffedUp/src/services/authService.dart';
import 'package:BuffedUp/src/widget/searchindicator.dart';
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
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
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
          if (_isLoading) SearchingIndicator(radius: 10,),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (mounted) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Use a local variable to check if the widget is mounted
                          bool isMounted = mounted;
                          if (isMounted) {
                            String result = await register(
                                emailController.text, passwordController.text);

                            // Check mounted again before calling setState()
                            if (mounted) {
                              setState(() {
                                message = result;
                                _isLoading = false;
                              });
                            }
                          }
                        }
                      },
                child: const Text("Register"),
              ),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (mounted) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Use a local variable to check if the widget is mounted
                          bool isMounted = mounted;
                          if (isMounted) {
                            String result = await login(
                                emailController.text, passwordController.text);

                            // Check mounted again before calling setState()
                            if (mounted) {
                              setState(() {
                                message = result;
                                _isLoading = false;
                              });
                            }
                          }
                        }
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
