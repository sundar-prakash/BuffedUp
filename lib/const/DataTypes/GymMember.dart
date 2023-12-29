import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GymMember {
  final String name;
  final String? email;
  final DateTime joinDate;
  final MembershipType membershipType;
  final String phoneNumber;
  final String? profilePicture;
  final int registerNumber;
  final String gymownerid;
  final String? homeaddress;
  final String? gender;
  final List<MeasurementType>? weightData;

  const GymMember({
    required this.name,
    this.email,
    required this.joinDate,
    required this.gymownerid,
    required this.registerNumber,
    required this.membershipType,
    required this.phoneNumber,
    this.weightData = const [],
    this.gender,
    this.profilePicture,
    this.homeaddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'joinDate': joinDate,
      'registerNumber': registerNumber,
      'homeaddress': homeaddress,
      'gymownerid': gymownerid,
      'gender': gender,
      'weightData': weightData?.map((e) => e.toMap()).toList(),
      'membershipType': {
        'amount': membershipType.amount,
        'category': membershipType.category,
        'paidon': membershipType.paidon,
        'expiryDate': membershipType.expiryDate,
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
      joinDate: timestampToDateTime(data['joinDate']),
      homeaddress: data['homeaddress'] ?? '',
      registerNumber: data['registerNumber'] ?? 0,
      gymownerid: data['gymownerid'] ?? '',
      gender: data['gender'] as String?,
      weightData: (data['weightData'] is List<dynamic> &&
              data['weightData'].every((e) => e is Map))
        ? (data['weightData'] as List<dynamic>)
            .map((e) => MeasurementType.fromMap(e as Map<String, dynamic>))
            .toList()
        : [],

      membershipType: MembershipType(
        expiryDate: timestampToDateTime(data['membershipType']['paidon']),
        amount: data['membershipType']['amount'] as int,
        paidon: timestampToDateTime(data['membershipType']['paidon']),
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
  final DateTime expiryDate;

  MembershipType(
      {required this.amount,
      required this.paidon,
      required this.validity,
      required this.expiryDate,
      this.category});
}

class MeasurementType {
  final double value;
  final DateTime recordedOn;

  MeasurementType({required this.value, required this.recordedOn});

  factory MeasurementType.fromMap(Map<String, dynamic> map) {
    return MeasurementType(
      value: map['value'].toDouble(),
      recordedOn: (map['recordedOn'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'recordedOn': recordedOn,
    };
  }
}

String DateTimetoString(DateTime d) {
  return DateFormat('yyyy-MM-dd').format(d);
}

DateTime StringtoDateTime(String d) {
  return DateTime.parse(d as String);
}

DateTime CalculateExpireDate(DateTime paidon, Duration days) {
  DateTime expirationDate = paidon.add(days);
  return expirationDate;
}

DateTime timestampToDateTime(Timestamp? timestamp) {
  return timestamp?.toDate() ?? DateTime.now();
}

Duration intToDays(int n) {
  return Duration(days: n);
}
