import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:wave/services/notification_token.dart';

class NotificationService {
  // for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(
      {required String fcmToken,
      required String title,
      required String message}) async {
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
        }
      };

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'wave-dev-42598';

      // get firebase admin token
      final bearerToken = await NotificationAccessToken.getToken;

      log('bearerToken: $bearerToken');

      // handle null token
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