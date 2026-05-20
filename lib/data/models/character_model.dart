class Character {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final List<String> personalityTraits;
  final String background;
  final String hiddenMotivation;
  final bool isMafia;
  final String connectionToVictim;

  const Character({
    required this.id,
    required this.name,
    required this.age,
    required this.occupation,
    required this.personalityTraits,
    required this.background,
    required this.hiddenMotivation,
    this.isMafia = false,
    required this.connectionToVictim,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      occupation: json['occupation'] as String,
      personalityTraits: List<String>.from(json['personalityTraits'] as List),
      background: json['background'] as String,
      hiddenMotivation: json['hiddenMotivation'] as String,
      isMafia: json['isMafia'] as bool? ?? false,
      connectionToVictim: json['connectionToVictim'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'occupation': occupation,
    'personalityTraits': personalityTraits,
    'background': background,
    'hiddenMotivation': hiddenMotivation,
    'isMafia': isMafia,
    'connectionToVictim': connectionToVictim,
  };
}