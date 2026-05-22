class GameMessage {
  final String type;
  final Map<String, dynamic> data;

  const GameMessage({required this.type, required this.data});

  factory GameMessage.fromJson(Map<String, dynamic> json) {
    return GameMessage(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'data': data};
}

class MessageTypes {
  // اتصال
  static const String join = 'join';
  static const String joined = 'joined';
  static const String playerList = 'player_list';
  static const String playerLeft = 'player_left';
  
  // اللعبة
  static const String gameStart = 'game_start';
  static const String caseDetails = 'case_details';
  static const String roleAssign = 'role_assign';
  static const String characterInfo = 'character_info';
  static const String evidenceShow = 'evidence_show';
  static const String discussionStart = 'discussion_start';
  static const String votingStart = 'voting_start';
  static const String voteCast = 'vote_cast';
  static const String voteResult = 'vote_result';
  static const String eliminationResult = 'elimination_result';
  static const String juryPhase = 'jury_phase';
  static const String gameEnd = 'game_end';
  static const String gameState = 'game_state';
}