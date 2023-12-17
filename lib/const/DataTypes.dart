

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
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'joinDate': joinDate.toIso8601String(), // Convert DateTime to String
      'registerNumber': registerNumber,
      'membershipType': {
        'amount': membershipType.amount,
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
      registerNumber: data['registerNumber'] ?? 0,
      membershipType: MembershipType(
        amount: data['membershipType']['amount'] as int,
        paidon: DateTime.parse(data['membershipType']['paidon'] as String),
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

class UserProfile {
  final String uid;
  final String email;
  String name;
  String bio;
  String phone;
  String avatar;
  String gymName;
  List<dynamic> members;
  List<dynamic> equipments;
  List<dynamic> expenses;

  UserProfile({
    required this.uid,
    required this.email,
    this.name = '',
    this.bio = '',
    this.phone = '',
    this.avatar = '',
    this.gymName = '',
    this.members = const [],
    this.equipments = const [],
    this.expenses = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'phone': phone,
      'avatar': avatar,
      'gymname': gymName,
      'members': members,
      'equipments': equipments,
      'expenses': expenses,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      bio: map['bio'] as String,
      phone: map['phone'] != null ? map['phone'] as String : '',
      avatar: map['avatar'] != null ? map['avatar'] as String : '',
      gymName: map['gymname'] != null ? map['gymname'] as String : '',
      members: (map['members'] as List<dynamic>?)?.toList() ?? [],
      equipments: (map['equipments'] as List<dynamic>?)?.toList() ?? [],
      expenses: (map['expenses'] as List<dynamic>?)?.toList() ?? [],
    );
  }
}
