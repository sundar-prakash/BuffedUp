import 'package:BuffedUp/src/widget/memberform.dart';
import 'package:flutter/material.dart';

class newmemberscreen extends StatelessWidget {
  newmemberscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Member"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: MemberForm(),
      ),
    );
  }
}
