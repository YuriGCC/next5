class Player {
  final int id;
  final String name;
  final String? position;

  Player({required this.id, required this.name, this.position});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      position: json['position'],
    );
  }
}