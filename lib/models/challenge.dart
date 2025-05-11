class Challenge {
  final int id;
  final String name;
  final String description;
  final int target;
  final String duration;

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.target,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'target': target,
      'duration': duration,
    };
  }

  static Challenge fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      target: map['target'] as int,
      duration: map['duration'] as String,
    );
  }

  @override
  String toString() {
    return 'Challenge(id: $id, name: $name, description: $description, target: $target, duration: $duration)';
  }
}