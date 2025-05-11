class Community {
  final int id;
  final String name;
  final String sportType;
  final String location;
  final String schedule;

  Community({
    required this.id,
    required this.name,
    required this.sportType,
    required this.location,
    required this.schedule,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sportType': sportType,
      'location': location,
      'schedule': schedule,
    };
  }

  static Community fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as int,
      name: map['name'] as String,
      sportType: map['sportType'] as String,
      location: map['location'] as String,
      schedule: map['schedule'] as String,
    );
  }

  @override
  String toString() {
    return 'Community(id: $id, name: $name, sportType: $sportType, location: $location, schedule: $schedule)';
  }
}