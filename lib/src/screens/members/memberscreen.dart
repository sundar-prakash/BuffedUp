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

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
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
      _isSearching = true;
      memberQuery = FirebaseFirestore.instance
          .collection('members')
          .where('gymownerid', isEqualTo: user.uid)
          .orderBy('registerNumber');
      _isLoading = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isSearching = false;
    });
  }

  Future<void> searchMembers(String query) async {
    setState(() {
      _isSearching = true;
      int? regno = int.tryParse(query);
      if (query.isNotEmpty) {
        if (regno != null) {
          memberQuery = FirebaseFirestore.instance
              .collection('members')
              .where('gymownerid', isEqualTo: user.uid)
              .where('registerNumber', isGreaterThanOrEqualTo: regno)
              .orderBy('registerNumber');
        } else {
          memberQuery = FirebaseFirestore.instance
              .collection('members')
              .where('gymownerid', isEqualTo: user.uid)
              .orderBy('name')
              .startAt([query.toLowerCase()]).endAt(['$query\uf7ff']);
        }
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

  Future<void> fetchActiveMembers() async {
    Timestamp currentTimestamp = Timestamp.now();
    setState(() {
      _isSearching = true;
      memberQuery = FirebaseFirestore.instance
          .collection('members')
          .where('gymownerid', isEqualTo: user.uid)
          .where('membershipType.expiryDate', isGreaterThan: currentTimestamp)
          .orderBy('membershipType.expiryDate');
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isSearching = false;
    });
  }

  Future<void> fetchExpiredMembers() async {
    Timestamp currentTimestamp = Timestamp.now();
    setState(() {
      _isSearching = true;
      memberQuery = FirebaseFirestore.instance
          .collection('members')
          .where('gymownerid', isEqualTo: user.uid)
          .where('membershipType.expiryDate',
              isLessThanOrEqualTo: currentTimestamp)
          .orderBy('membershipType.expiryDate');
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
                    builder: (context) => NewMemberScreen(user.uid)),
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
                        label: Text("Search Name,Reg Number..."),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    _FilterRadioButtons(
                      currentFilter: _currentFilter,
                      onChanged: (newValue) {
                        setState(() {
                          _currentFilter = newValue;
                        });
                        if (_currentFilter == 0) {
                          fetchInitialData();
                        } else if (_currentFilter == 1) {
                          fetchActiveMembers();
                        } else if (_currentFilter == 2) {
                          fetchExpiredMembers();
                        }
                      },
                    ),
                    Expanded(
                      child: _isSearching
                          ? SearchingIndicator(
                              text: "Searching for Gym Rats...")
                          : FirestorePagination(
                              initialLoader: SearchingIndicator(
                                  text: "Searching for Gym Rats..."),
                              limit: 15,
                              bottomLoader: const Center(
                                  child: Text("Fetching data from Gene...")),
                              isLive: true,
                              query: memberQuery,
                              itemBuilder: (context, documentSnapshot, index) {
                                final member = GymMember.fromMap(
                                    documentSnapshot.data()
                                        as Map<String, dynamic>);

                                return MemberTile(user.uid, member);
                              },
                            ),
                    ),
                  ],
                )));
  }
}

class _FilterRadioButtons extends StatelessWidget {
  final int currentFilter;
  final ValueChanged<int> onChanged;

  const _FilterRadioButtons({
    super.key,
    required this.currentFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 5),
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
