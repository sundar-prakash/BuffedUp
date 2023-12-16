// ignore_for_file: camel_case_types

import 'package:BuffedUp/const/DataTypes.dart';
import 'package:BuffedUp/src/screens/members/newmemberscreen.dart';
import 'package:BuffedUp/src/services/firestore/getData.dart';
import 'package:BuffedUp/src/widget/membertile.dart';
import 'package:flutter/material.dart';

class memberscreen extends StatefulWidget {
  const memberscreen({super.key});

  @override
  State<memberscreen> createState() => _memberscreenState();
}

class _memberscreenState extends State<memberscreen> {
  List<GymMember> members = [];
  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    fetchMembers().then((members) => setState(() => this.members = members));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text("Members"),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => newmemberscreen())),
                icon: const Icon(Icons.add_circle_outline))
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async => refresh(),
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                        label: Text("Search name,reg,phone..."),
                        prefixIcon: Icon(Icons.search)),
                  ),
                  if (members.isEmpty)
                    Container(
                        margin: EdgeInsets.all(20),
                        child: CircularProgressIndicator())
                  else
                    Column(
                      children: members.map((e) => membertile(e)).toList(),
                    )
                ],
              ),
            ))));
  }
}
