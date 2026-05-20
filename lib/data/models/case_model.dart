import 'character_model.dart';
import 'evidence_model.dart';

class GameCase {
  final String id;
  final String title;
  final String description;
  final String location;
  final String timeOfCrime;
  final String victimName;
  final String victimProfile;
  final List<Character> suspects;
  final List<Evidence> evidenceCards;
  final int mafiaCount;
  final String narrativeAmbiguity;

  const GameCase({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.timeOfCrime,
    required this.victimName,
    required this.victimProfile,
    required this.suspects,
    required this.evidenceCards,
    required this.mafiaCount,
    required this.narrativeAmbiguity,
  });

  factory GameCase.fromJson(Map<String, dynamic> json) {
    return GameCase(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      timeOfCrime: json['timeOfCrime'] as String,
      victimName: json['victimName'] as String,
      victimProfile: json['victimProfile'] as String,
      suspects: (json['suspects'] as List)
          .map((s) => Character.fromJson(s as Map<String, dynamic>))
          .toList(),
      evidenceCards: (json['evidenceCards'] as List)
          .map((e) => Evidence.fromJson(e as Map<String, dynamic>))
          .toList(),
      mafiaCount: json['mafiaCount'] as int,
      narrativeAmbiguity: json['narrativeAmbiguity'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'timeOfCrime': timeOfCrime,
    'victimName': victimName,
    'victimProfile': victimProfile,
    'suspects': suspects.map((s) => s.toJson()).toList(),
    'evidenceCards': evidenceCards.map((e) => e.toJson()).toList(),
    'mafiaCount': mafiaCount,
    'narrativeAmbiguity': narrativeAmbiguity,
  };
}