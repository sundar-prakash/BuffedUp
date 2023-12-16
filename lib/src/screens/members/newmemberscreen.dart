import 'package:BuffedUp/src/widget/memberform.dart';
import 'package:flutter/material.dart';

class newmemberscreen extends StatelessWidget {
  newmemberscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Member"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: const MemberForm(),
      ),
    );
  }
}
