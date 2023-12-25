class EquipmentType {
  String name;
  String? description;
  int count;

  EquipmentType({
    required this.name,
    this.description,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'count': count,
    };
  }

  factory EquipmentType.fromMap(Map<String, dynamic> map) {
    return EquipmentType(
      name: map['name'] as String,
      description: map['description'] as String?,
      count: map['count'] as int,
    );
  }
}
