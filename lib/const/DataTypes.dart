class GymMember {
  final String name;
  final String? email;
  final DateTime joinDate;
  final MembershipType membershipType;
  final String phoneNumber;
  final String? profilePicture;
  final int registerNumber;

  const GymMember({
    required this.name,
    this.email,
    required this.joinDate,
    required this.registerNumber,
    required this.membershipType,
    required this.phoneNumber,
    this.profilePicture,
  });
  static GymMember fromJson(Map<String, dynamic> data) {
    return GymMember(
      name: data['name'] as String,
      email: data['email'] as String?,
      joinDate: data['joinDate'].toDate(),
      registerNumber: data['registerNumber'] ?? 0,
      membershipType: MembershipType(
        amount: data['membershipType']['amount'] as int,
        paidon: data['membershipType']['paidon'].toDate(),
        validity: Duration(days: data['membershipType']['validity'] as int),
      ),
      phoneNumber: data['phoneNumber'] as String,
      profilePicture: data['profilePicture'] as String?,
    );
  }
}

class MembershipType {
  final int amount;
  final DateTime paidon;
  final Duration validity;
  MembershipType(
      {required this.amount, required this.paidon, required this.validity});
}

