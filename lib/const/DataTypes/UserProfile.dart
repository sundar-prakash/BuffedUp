import 'package:BuffedUp/const/DataTypes/GymMember.dart';

class UserProfile {
  final String uid;
  final String email;
  String name;
  String bio;
  String phone;
  String avatar;
  String gymName;
  notesType? notes;
  List<PaymentHistory>? subscriptionHistory;
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
    this.subscriptionHistory,
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
      'subscriptionHistory': subscriptionHistory,
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
      subscriptionHistory: (map['subscriptionHistory'] as List<dynamic>?)
              ?.map((historyMap) => PaymentHistory.fromMap(historyMap))
              .toList() ??
          [],
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

class SubscriptionPlan {
  final int id;
  final String name;
  final double price;
  final int limit;
  final Duration validity;
  final List<String> description;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.limit,
    required this.validity,
    required this.description,
  });

  factory SubscriptionPlan.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlan(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      limit: map['limit'] ?? 0,
      price: (map['price'] ?? 0.0).toDouble(),
      validity: Duration(days: map['validity_days'] ?? 0),
      description: List<String>.from(map['description'] ?? []),
    );
  }
}

class PaymentHistory {
  final int planID;
  final String gateway;
  final DateTime paidOn;
  final DateTime expiryDate;
  final String transactionid;

  PaymentHistory({
    required this.planID,
    required this.paidOn,
    required this.expiryDate,
    required this.transactionid,
    required this.gateway,
  });

  Map<String, dynamic> toMap() {
    return {
      'planID': planID,
      'gateway': gateway,
      'paidOn': paidOn,
      'expiryDate': expiryDate,
      'transactionid': transactionid,
    };
  }

  factory PaymentHistory.fromMap(Map<String, dynamic> map) {
    return PaymentHistory(
      planID: map['planID'] as int,
      gateway: map['gateway'] as String,
      paidOn: timestampToDateTime(map['paidOn']),
      expiryDate: timestampToDateTime(map['expiryDate']),
      transactionid: map['transactionid'] as String,
    );
  }
}
