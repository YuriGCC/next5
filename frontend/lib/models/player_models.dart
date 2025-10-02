class Player {
  final int id;
  final String name;
  final String? position;
  final String? jerseyNumber;

  Player({required this.id, required this.name, this.position, this.jerseyNumber});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      jerseyNumber: json['jersey_number']
    );
  }
}