// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomResponse {

  final bool responseStatus; // Returns true if the operation was successful, otherwise false.
  dynamic response; // Returns a dynamic value if required by the situation

  CustomResponse({
    required this.responseStatus,
    this.response,
  });

  CustomResponse copyWith({
    bool? responseStatus,
    dynamic response,
  }) {
    return CustomResponse(
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

  factory CustomResponse.fromMap(Map<String, dynamic> map) {
    return CustomResponse(
      responseStatus: map['responseStatus'] as bool,
      response: map['response'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomResponse.fromJson(String source) =>
      CustomResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomResponse(responseStatus: $responseStatus, response: $response)';

  @override
  bool operator ==(covariant CustomResponse other) {
    if (identical(this, other)) return true;

    return other.responseStatus == responseStatus && other.response == response;
  }

  @override
  int get hashCode => responseStatus.hashCode ^ response.hashCode;
}
