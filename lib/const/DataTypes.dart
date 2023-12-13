class GymMember {
  final String name;
  final String? email;
  final DateTime joinDate;
  final MembershipType membershipType;
  final String phoneNumber;
  final String? profilePicture;
  final int reqisterNumber;

  const GymMember({
    required this.name,
    this.email,
    required this.joinDate,
    required this.reqisterNumber,
    required this.membershipType,
    required this.phoneNumber,
    this.profilePicture,
  });
}

class MembershipType {
  final int amount;
  final DateTime paidon;
  final Duration validity;
  MembershipType(
      {required this.amount, required this.paidon, required this.validity});
}

//Dummy data
List<GymMember> members = [
  GymMember(
      name: "Sundar",
      joinDate: DateTime(2021, 01, 2),
      reqisterNumber: 888,
      membershipType: MembershipType(
          amount: 5000,
          paidon: DateTime(2021, 09, 2),
          validity: Duration(days: 365)),
      phoneNumber: "8838"),
  GymMember(
      name: "Sas",
      joinDate: DateTime(2021, 09, 3),
      reqisterNumber: 889,
      membershipType: MembershipType(
          amount: 1500,
          paidon: DateTime(2021, 09, 3),
          validity: Duration(days: 90)),
      phoneNumber: "7401"),
];
