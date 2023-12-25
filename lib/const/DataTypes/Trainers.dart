class Trainer {
  final String name;
  final String? email;
  final DateTime joinDate;
  final String phoneNumber;
  final String? profilePicture;
  final int registerNumber;
  final String gender;
  final String? homeaddress;

  const Trainer({
    required this.name,
    this.email,
    required this.joinDate,
    required this.registerNumber,
    required this.phoneNumber,
    required this.gender,
    this.profilePicture,
    this.homeaddress,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'joinDate': joinDate.toIso8601String(),
      'registerNumber': registerNumber,
      'homeaddress': homeaddress,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'profilePicture': profilePicture,
    };
  }

  static Trainer fromMap(Map<String, dynamic> data) {
    return Trainer(
      name: data['name'] as String,
      email: data['email'] as String?,
      joinDate: DateTime.parse(data['joinDate'] as String),
      homeaddress: data['homeaddress'] ?? '',
      registerNumber: data['registerNumber'] ?? 0,
      gender: data['gender'] as String,
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
