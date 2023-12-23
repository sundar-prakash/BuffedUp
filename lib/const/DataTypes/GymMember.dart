class GymMember {
  final String name;
  final String? email;
  final DateTime joinDate;
  final MembershipType membershipType;
  final String phoneNumber;
  final String? profilePicture;
  final int registerNumber;
  final String? homeaddress;

  const GymMember({
    required this.name,
    this.email,
    required this.joinDate,
    required this.registerNumber,
    required this.membershipType,
    required this.phoneNumber,
    this.profilePicture,
    this.homeaddress,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'joinDate': joinDate.toIso8601String(), // Convert DateTime to String
      'registerNumber': registerNumber,
      'homeaddress': homeaddress,
      'membershipType': {
        'amount': membershipType.amount,
        'category': membershipType.category,
        'paidon': membershipType.paidon
            .toIso8601String(), // Convert DateTime to String
        'validity': membershipType.validity.inDays,
      },
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }

  static GymMember fromMap(Map<String, dynamic> data) {
    return GymMember(
      name: data['name'] as String,
      email: data['email'] as String?,
      joinDate: DateTime.parse(data['joinDate'] as String),
      homeaddress: data['homeaddress'] ?? '',
      registerNumber: data['registerNumber'] ?? 0,
      membershipType: MembershipType(
        amount: data['membershipType']['amount'] as int,
        paidon: DateTime.parse(data['membershipType']['paidon'] as String),
        category: data['membershipType']['category'] ?? "",
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
  final String? category;

  MembershipType(
      {required this.amount,
      required this.paidon,
      required this.validity,
      this.category});
}
