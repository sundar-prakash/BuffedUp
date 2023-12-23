import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/screens/members/newmemberscreen.dart';
import 'package:BuffedUp/src/services/firestore/getData.dart';
import 'package:BuffedUp/src/widget/customradiobutton.dart';
import 'package:BuffedUp/src/widget/membertile.dart';
import 'package:BuffedUp/src/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class memberscreen extends StatefulWidget {
  memberscreen({Key? key}) : super(key: key);

  @override
  State<memberscreen> createState() => _memberscreenState();
}

class _memberscreenState extends State<memberscreen> {
  late List<GymMember> allMembers = [];
  List<GymMember> displayedMembers = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _isMemberEmpty = true;
  int _currentPage = 0;
  int _pageSize = 10;
  int _currentFilter = 0;
  late int _previousFilter = 0;

  @override
  void initState() {
    super.initState();
    refreshMemberscreen();
  }

  List<GymMember> getExpiredMembers() {
    return allMembers.where((member) {
      return isMembershipExpired(
          member.membershipType.paidon, member.membershipType.validity);
    }).toList();
  }

  List<GymMember> getActiveMembers() {
    return allMembers.where((member) {
      return !isMembershipExpired(
          member.membershipType.paidon, member.membershipType.validity);
    }).toList();
  }

  List<GymMember> sortMembers() {
    return allMembers
      ..sort((a, b) => a.registerNumber.compareTo(b.registerNumber));
  }

  void refreshMemberscreen() async {
    setState(() => _isLoading = true);

    await fetchAllMembers().then((members) {
      setState(() {
        _isLoading = false;
        if (members.isNotEmpty) _isMemberEmpty = false;
        allMembers = members;
        displayedMembers = _loadNextPage();
      });
    });
  }

  List<GymMember> _loadNextPage() {
    int endIndex = (_currentPage + 1) * _pageSize;
    if (endIndex > allMembers.length) {
      endIndex = allMembers.length;
    }
    return allMembers.sublist(0, endIndex);
  }

  void loadMoreMembers() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _currentPage++;
      displayedMembers.addAll(_loadNextPage());
    });
  }

  void searchMembers(String query) {
    final String lowerCaseQuery = query.toLowerCase();

    setState(() {
      if (lowerCaseQuery.isEmpty) {
        refreshMemberscreen();
      } else {
        displayedMembers = allMembers
            .where(
                (member) => member.name.toLowerCase().contains(lowerCaseQuery))
            .toList();
      }
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
            onPressed: () => refreshMemberscreen(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => newmemberscreen()),
            ),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(
                  radius: 30,
                ),
                MediumText("Please wait...")
              ],
            ))
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoading &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  loadMoreMembers();
                }
                return true;
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        label: Text("Search name..."),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    if (displayedMembers.isEmpty)
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: _isMemberEmpty
                            ? const Text("No members found :(")
                            : const CupertinoActivityIndicator(
                                radius: 20,
                              ),
                      )
                    else
                      Column(
                        children: [
                          FilterRadioButtons(
                            currentFilter: _currentFilter,
                            onChanged: (newValue) {
                              setState(() {
                                _currentFilter = newValue;
                              });
                              updateDisplayedMembers();
                            },
                          ),
                          Column(
                            children: displayedMembers
                                .map((e) => membertile(e))
                                .toList(),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
    );
  }

  void updateDisplayedMembers() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      if (_currentFilter == 1) {
        displayedMembers = sortMembers();
      } else if (_currentFilter == 2) {
        displayedMembers = getActiveMembers();
      } else if (_currentFilter == 3) {
        displayedMembers = getExpiredMembers();
      }
      if (_currentFilter == _previousFilter) {
        _currentFilter = 0;
        displayedMembers = allMembers;
      }
      _previousFilter = _currentFilter;
      _isLoading = false;
    });
  }
}

class FilterRadioButtons extends StatelessWidget {
  final int currentFilter;
  final ValueChanged<int> onChanged;

  const FilterRadioButtons({
    Key? key,
    required this.currentFilter,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.filter_list_alt),
        CustomRadioButton(
          text: "Reg no",
          value: 1,
          groupValue: currentFilter,
          onChanged: onChanged,
        ),
        CustomRadioButton(
          text: "Active",
          value: 2,
          groupValue: currentFilter,
          onChanged: onChanged,
        ),
        CustomRadioButton(
          text: "Expired",
          value: 3,
          groupValue: currentFilter,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
