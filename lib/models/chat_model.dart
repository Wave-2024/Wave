// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chat {
  String id;
  String firstUser;
  String secondUser;
  String lastMessage;
  DateTime timeOfLastMessage;
  Chat({
    required this.id,
    required this.firstUser,
    required this.secondUser,
    required this.lastMessage,
    required this.timeOfLastMessage,
  });



  Chat copyWith({
    String? id,
    String? firstUser,
    String? secondUser,
    String? lastMessage,
    DateTime? timeOfLastMessage,
  }) {
    return Chat(
      id: id ?? this.id,
      firstUser: firstUser ?? this.firstUser,
      secondUser: secondUser ?? this.secondUser,
      lastMessage: lastMessage ?? this.lastMessage,
      timeOfLastMessage: timeOfLastMessage ?? this.timeOfLastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstUser': firstUser,
      'secondUser': secondUser,
      'lastMessage': lastMessage,
      'timeOfLastMessage': timeOfLastMessage.millisecondsSinceEpoch,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      firstUser: map['firstUser'] as String,
      secondUser: map['secondUser'] as String,
      lastMessage: map['lastMessage'] as String,
      timeOfLastMessage: DateTime.fromMillisecondsSinceEpoch(map['timeOfLastMessage'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(id: $id, firstUser: $firstUser, secondUser: $secondUser, lastMessage: $lastMessage, timeOfLastMessage: $timeOfLastMessage)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.firstUser == firstUser &&
      other.secondUser == secondUser &&
      other.lastMessage == lastMessage &&
      other.timeOfLastMessage == timeOfLastMessage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstUser.hashCode ^
      secondUser.hashCode ^
      lastMessage.hashCode ^
      timeOfLastMessage.hashCode;
  }
}
