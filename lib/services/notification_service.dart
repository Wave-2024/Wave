import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:wave/services/notification_token.dart';

class NotificationService {
  // for sending push notification (Updated Codes)
 static Future<void> sendPushNotification({
  required String fcmToken,
  required String title,
  required String message,
  Map<String, String>? data, // Added data parameter
}) async {
  try {
    final body = {
      "message": {
        "token": fcmToken,
        "apns": {
          "payload": {
            "aps": {"content-available": 1}
          }
        },
        "notification": {
          "title": title,
          "body": message,
        },
        "data": data // Adding data to the payload
      }
    };

    const projectID = 'wave-dev-42598';
    final bearerToken = await NotificationAccessToken.getToken;

    log('bearerToken: $bearerToken');

    if (bearerToken == null) return;

    var res = await post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
      },
      body: jsonEncode(body),
    );

    log('Response status: ${res.statusCode}');
    log('Response body: ${res.body}');
  } catch (e) {
    log('\nsendPushNotificationE: $e');
  }
}

}