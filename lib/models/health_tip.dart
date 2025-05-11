class HealthTip {
  final int id;
  final String sportType;
  final String tip;

  HealthTip({
    required this.id,
    required this.sportType,
    required this.tip,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sportType': sportType,
      'tip': tip,
    };
  }

  static HealthTip fromMap(Map<String, dynamic> map) {
    return HealthTip(
      id: map['id'] as int,
      sportType: map['sportType'] as String,
      tip: map['tip'] as String,
    );
  }
}