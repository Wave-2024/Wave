// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostContent {
  String type;
  /* type cane be of image,video */
  String url;

  bool isMediaLandscape;
  PostContent({
    required this.type,
    required this.url,
    required this.isMediaLandscape,
  });

  PostContent copyWith({
    String? type,
    String? url,
    bool? isMediaLandscape,
  }) {
    return PostContent(
      type: type ?? this.type,
      url: url ?? this.url,
      isMediaLandscape: isMediaLandscape ?? this.isMediaLandscape,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'url': url,
      'isMediaLandscape': isMediaLandscape,
    };
  }

  factory PostContent.fromMap(Map<String, dynamic> map) {
    return PostContent(
      type: map['type'] as String,
      url: map['url'] as String,
      isMediaLandscape: map['isMediaLandscape'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostContent.fromJson(String source) =>
      PostContent.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PostContent(type: $type, url: $url, isMediaLandscape: $isMediaLandscape)';

  @override
  bool operator ==(covariant PostContent other) {
    if (identical(this, other)) return true;
  
    return 
      other.type == type &&
      other.url == url &&
      other.isMediaLandscape == isMediaLandscape;
  }

  @override
  int get hashCode => type.hashCode ^ url.hashCode ^ isMediaLandscape.hashCode;
}
