import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/screens/members/newmemberscreen.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:BuffedUp/src/widget/customradiobutton.dart';
import 'package:BuffedUp/src/widget/membertile.dart';
import 'package:BuffedUp/src/widget/searchindicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';

class memberscreen extends StatefulWidget {
  memberscreen({Key? key}) : super(key: key);

  @override
  State<memberscreen> createState() => _memberscreenState();
}

class _memberscreenState extends State<memberscreen> {
  final TextEditingController _searchController = TextEditingController();
  late UserProfile user;
  bool _isLoading = true;
  bool _isSearching = false;
  int _currentFilter = 0;
  late Query memberQuery;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    user = await fetchOwner();
    setState(() {
      memberQuery = FirebaseFirestore.instance
          .collection('members')
          .where('gymownerid', isEqualTo: user.uid)
          .orderBy('registerNumber');
      _isLoading = false;
    });
  }

  Future<void> fetchActiveMembers() async {
    memberQuery = FirebaseFirestore.instance
        .collection('members')
        .where('gymownerid', isEqualTo: user.uid)
        .where('expiryDate', isGreaterThan: DateTime.now())
        .orderBy('registerNumber');
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulating delay
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchExpiredMembers() async {
    memberQuery = FirebaseFirestore.instance
        .collection('members')
        .where('gymownerid', isEqualTo: user.uid)
        .where('expiryDate', isLessThan: DateTime.now())
        .orderBy('registerNumber');
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulating delay
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> searchMembers(String query) async {
    setState(() {
      _isSearching = true;
      int? regno = int.tryParse(query);
      if (query != "" && regno != null) {
        memberQuery = FirebaseFirestore.instance
            .collection('members')
            .where('gymownerid', isEqualTo: user.uid)
            .where('registerNumber', isGreaterThanOrEqualTo: regno)
            .orderBy('registerNumber');
      } else {
        memberQuery = FirebaseFirestore.instance
            .collection('members')
            .where('gymownerid', isEqualTo: user.uid)
            .orderBy('registerNumber');
      }
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isSearching = false;
    });
  }

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
                MaterialPageRoute(
                    builder: (context) => newmemberscreen(user.uid)),
              ),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: SearchingIndicator(text: "Please wait..."))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          searchMembers(query);
                        });
                      },
                      decoration: const InputDecoration(
                        label: Text("Search Reg Number..."),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    FilterRadioButtons(
                      currentFilter: _currentFilter,
                      onChanged: (newValue) {
                        setState(() {
                          _currentFilter = newValue;
                        });
                        // if (_currentFilter == 0) {
                        //   fetchInitialData();
                        // } else if (_currentFilter == 1) {
                        //   fetchActiveMembers();
                        // } else if (_currentFilter == 2) {
                        //   fetchExpiredMembers();
                        // }
                      },
                    ),
                    Expanded(
                      child: _isSearching
                          ? SearchingIndicator(
                              text: "Searching for Gym Rats...")
                          : FirestorePagination(
                              initialLoader: SearchingIndicator(
                                  text: "Searching for Gym Rats..."),
                              limit: 12,
                              bottomLoader: const Center(
                                  child: Text("Fetching data from Gene...")),
                              isLive: true,
                              query: memberQuery,
                              itemBuilder: (context, documentSnapshot, index) {
                                final member = GymMember.fromMap(
                                    documentSnapshot.data()
                                        as Map<String, dynamic>);

                                return membertile(user.uid, member);
                              },
                            ),
                    ),
                  ],
                )));
  }
}

class FilterRadioButtons extends StatelessWidget {
  final int currentFilter;
  final ValueChanged<int> onChanged;

  const FilterRadioButtons({
    super.key,
    required this.currentFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            const Icon(Icons.filter_list_alt),
            CustomRadioButton(
              text: "All",
              value: 0,
              groupValue: currentFilter,
              onChanged: onChanged,
            ),
            CustomRadioButton(
              text: "Active",
              value: 1,
              groupValue: currentFilter,
              onChanged: onChanged,
            ),
            CustomRadioButton(
              text: "Expired",
              value: 2,
              groupValue: currentFilter,
              onChanged: onChanged,
            ),
          ],
        ));
  }
}
