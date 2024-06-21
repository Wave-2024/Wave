import 'dart:convert';
import 'package:wave/utils/enums.dart';

class Message {
  String message;
  String sender;
  DateTime createdAt;
  MESSAGE_TYPE message_type;
  String id;
  String chatId;
  bool seen;

  Message({
    required this.message,
    required this.sender,
    required this.createdAt,
    required this.message_type,
    required this.id,
    required this.chatId,
    this.seen = false,
  });

  Message copyWith({
    String? message,
    String? sender,
    DateTime? createdAt,
    MESSAGE_TYPE? message_type,
    String? id,
    String? chatId,
    bool? seen,
  }) {
    return Message(
      message: message ?? this.message,
      sender: sender ?? this.sender,
      createdAt: createdAt ?? this.createdAt,
      message_type: message_type ?? this.message_type,
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      seen: seen ?? this.seen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'sender': sender,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'message_type': message_type.toString().split('.').last,
      'id': id,
      'chatId': chatId,
      'seen': seen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] as String,
      sender: map['sender'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      id: map['id'] as String,
      chatId: map['chatId'] as String,
      message_type: map['message_type'] != null
          ? (map['message_type'] == 'TEXT')
          ? MESSAGE_TYPE.TEXT
          : MESSAGE_TYPE.IMAGE
          : MESSAGE_TYPE.TEXT,
      seen: map['seen'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(message: $message, sender: $sender, createdAt: $createdAt, message_type: $message_type, id: $id, chatId: $chatId, seen: $seen)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.sender == sender &&
        other.createdAt == createdAt &&
        other.message_type == message_type &&
        other.id == id &&
        other.chatId == chatId &&
        other.seen == seen;
  }

  @override
  int get hashCode {
    return message.hashCode ^
    sender.hashCode ^
    createdAt.hashCode ^
    message_type.hashCode ^
    id.hashCode ^
    chatId.hashCode ^
    seen.hashCode;
  }
}
