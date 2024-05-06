// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Like {
  String id;
  String userId;
  DateTime createdAt;
  Like({
    required this.id,
    required this.userId,
    required this.createdAt,
  });
  

  Like copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
  }) {
    return Like(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'] as String,
      userId: map['userId'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Like.fromJson(String source) => Like.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Like(id: $id, userId: $userId, createdAt: $createdAt)';

  @override
  bool operator ==(covariant Like other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ createdAt.hashCode;
}
