class UserProfile {
  final String uid;
  final String email;
  String name;
  String bio;
  String phone;
  String avatar;
  String gymName;
  notesType? notes;
  List<dynamic> members;
  List<dynamic> trainers;
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
    this.notes,
    this.members = const [],
    this.trainers = const [],
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
      'trainers': trainers,
      'notes': notes?.toMap(), // Convert notesType to a map
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
      notes: notesType.fromMap(map['notes'] as Map<String, dynamic>?),
      phone: map['phone'] != null ? map['phone'] as String : '',
      avatar: map['avatar'] != null ? map['avatar'] as String : '',
      gymName: map['gymname'] != null ? map['gymname'] as String : '',
      members: (map['members'] as List<dynamic>?)?.toList() ?? [],
      equipments: (map['equipments'] as List<dynamic>?)?.toList() ?? [],
      expenses: (map['expenses'] as List<dynamic>?)?.toList() ?? [],
      trainers: (map['trainers'] as List<dynamic>?)?.toList() ?? [],
    );
  }
}

class notesType {
  int colorIndex;
  String text;
  DateTime? lastSaved;

  notesType({
    this.text = "",
    this.colorIndex = 0,
    this.lastSaved,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'colorIndex': colorIndex,
      'lastSaved': lastSaved?.toIso8601String(),
    };
  }

  factory notesType.fromMap(Map<String, dynamic>? map) {
    if (map == null) return notesType();

    return notesType(
      text: map['text'] as String? ?? "",
      colorIndex: map['colorIndex'] as int? ?? 0,
      lastSaved: map['lastSaved'] != null
          ? DateTime.parse(map['lastSaved'] as String)
          : null,
    );
  }
}
