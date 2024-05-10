// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostContent {
  String type;
  String url;
  PostContent({
    required this.type,
    required this.url,
  });

  PostContent copyWith({
    String? type,
    String? url,
  }) {
    return PostContent(
      type: type ?? this.type,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'url': url,
    };
  }

  factory PostContent.fromMap(Map<String, dynamic> map) {
    return PostContent(
      type: map['type'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostContent.fromJson(String source) =>
      PostContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PostContent(type: $type, url: $url)';

  @override
  bool operator ==(covariant PostContent other) {
    if (identical(this, other)) return true;

    return other.type == type && other.url == url;
  }

  @override
  int get hashCode => type.hashCode ^ url.hashCode;
}
