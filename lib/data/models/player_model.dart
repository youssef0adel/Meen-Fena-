class Player {
  final String id;
  final String name;
  final String characterId;
  final bool isAlive;
  final bool isMafia;
  final int? votesReceived;
  final bool isEliminated;

  const Player({
    required this.id,
    required this.name,
    required this.characterId,
    this.isAlive = true,
    this.isMafia = false,
    this.votesReceived,
    this.isEliminated = false,
  });

  Player copyWith({
    String? id, String? name, String? characterId,
    bool? isAlive, bool? isMafia, int? votesReceived, bool? isEliminated,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      characterId: characterId ?? this.characterId,
      isAlive: isAlive ?? this.isAlive,
      isMafia: isMafia ?? this.isMafia,
      votesReceived: votesReceived ?? this.votesReceived,
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }
}