class Activity {
  final int id;
  final String type;
  final int duration;
  final String date;

  Activity({
    required this.id,
    required this.type,
    required this.duration,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'duration': duration,
      'date': date,
    };
  }

  static Activity fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as int? ?? 0, // Default ke 0 jika null
      type: map['type'] as String? ?? '', // Default ke string kosong jika null
      duration: map['duration'] as int? ?? 0, // Default ke 0 jika null
      date: map['date'] as String? ?? '', // Default ke string kosong jika null
    );
  }
}