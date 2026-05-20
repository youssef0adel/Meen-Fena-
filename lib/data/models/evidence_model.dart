class Evidence {
  final String id;
  final String title;
  final String description;
  final String suspiciousHint;
  final List<String> implicatedSuspects;
  final EvidenceType type;
  final String visualTheme;

  const Evidence({
    required this.id,
    required this.title,
    required this.description,
    required this.suspiciousHint,
    required this.implicatedSuspects,
    required this.type,
    required this.visualTheme,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) {
    return Evidence(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      suspiciousHint: json['suspiciousHint'] as String,
      implicatedSuspects: List<String>.from(json['implicatedSuspects'] as List),
      type: EvidenceType.values.firstWhere(
        (e) => e.toString() == 'EvidenceType.${json['type']}',
      ),
      visualTheme: json['visualTheme'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'suspiciousHint': suspiciousHint,
    'implicatedSuspects': implicatedSuspects,
    'type': type.toString().split('.').last,
    'visualTheme': visualTheme,
  };
}

enum EvidenceType {
  physical,
  digital,
  testimony,
  forensic,
  circumstantial,
}