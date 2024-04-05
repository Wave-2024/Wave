// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Response {
  final bool responseStatus;
  dynamic response;
  Response({
    required this.responseStatus,
    this.response,
  });

  Response copyWith({
    bool? responseStatus,
    dynamic response,
  }) {
    return Response(
      responseStatus: responseStatus ?? this.responseStatus,
      response: response ?? this.response,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'responseStatus': responseStatus,
      'response': response,
    };
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(
      responseStatus: map['responseStatus'] as bool,
      response: map['response'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory Response.fromJson(String source) =>
      Response.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Response(responseStatus: $responseStatus, response: $response)';

  @override
  bool operator ==(covariant Response other) {
    if (identical(this, other)) return true;

    return other.responseStatus == responseStatus && other.response == response;
  }

  @override
  int get hashCode => responseStatus.hashCode ^ response.hashCode;
}
