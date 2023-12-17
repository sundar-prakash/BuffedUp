// ignore_for_file: camel_case_types

import 'package:BuffedUp/const/DataTypes.dart';
import 'package:BuffedUp/src/screens/members/newmemberscreen.dart';
import 'package:BuffedUp/src/services/firestore/getData.dart';
import 'package:BuffedUp/src/widget/membertile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class memberscreen extends StatefulWidget {
  memberscreen({Key? key}) : super(key: key);

  @override
  State<memberscreen> createState() => _memberscreenState();
}

class _memberscreenState extends State<memberscreen> {
  late List<GymMember> allMembers;
  List<GymMember> displayedMembers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshMemberscreen();
  }

  void refreshMemberscreen() async {
    fetchMembers().then((members) {
      setState(() {
        allMembers = members;
        displayedMembers = members;
      });
    });
  }

  bool isMemberEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Members"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => newmemberscreen()),
            ),
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => refreshMemberscreen(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (query) {
                  final String lowerCaseQuery = query.toLowerCase();

                  setState(() {
                    if (lowerCaseQuery.isNotEmpty &&
                        displayedMembers.isNotEmpty) isMemberEmpty = true;
                    if (lowerCaseQuery.isEmpty) {
                      refreshMemberscreen();
                    } else {
                      displayedMembers = allMembers
                          .where((member) => member.name
                              .toLowerCase()
                              .contains(lowerCaseQuery))
                          .toList();
                    }
                  });
                },
                decoration: const InputDecoration(
                  label: Text("Search name..."),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              if (displayedMembers.isEmpty)
                Container(
                  margin: const EdgeInsets.all(20),
                  child: isMemberEmpty
                      ? const Text("No members found :(")
                      : const CupertinoActivityIndicator(
                          radius: 20,
                        ),
                )
              else
                Column(
                  children: displayedMembers.map((e) => membertile(e)).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
