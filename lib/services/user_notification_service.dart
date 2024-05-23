import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:wave/services/notification_token.dart';

class UserNotificationService {
  final String _serverToken = 'YOUR_SERVER_KEY';

  // for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(String fcmToken) async {
    try {
      
      final body = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": "my name", //our name should be send
            "body": "my msgs",
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

  Future<void> sendFollowNotification(String followerId, String followedUserId) async {
    try {
      // Get the FCM token of the followed user
      // Assuming you have stored FCM tokens in a Firestore collection named 'users'
      String fcmToken = await _getFcmToken(followedUserId);

      if (fcmToken.isNotEmpty) {
        // Get the follower's username
        String followerUsername = await _getUsername(followerId);

        // Create the notification payload
        Map<String, dynamic> notificationPayload = {
          'to': fcmToken,
          'notification': {
            'title': 'New Follower',
            'body': '$followerUsername has followed you',
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
        };

        // Send the notification using HTTP POST request
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$_serverToken',
          },
          body: jsonEncode(notificationPayload),
        );
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<String> _getFcmToken(String userId) async {
    // Implement logic to retrieve FCM token from Firestore or any other storage
    // For demonstration purpose, assume FCM tokens are stored in a Firestore collection named 'users'
    // Replace this with your actual logic to retrieve FCM token
    // You may need to handle cases where FCM token is not found
    // Here's a dummy implementation assuming Firestore is used
    String fcmToken = ''; // Default value if token is not found

    // Example: Retrieve FCM token from Firestore
    // Replace 'users' with your Firestore collection name
    // Replace 'fcmToken' with the field name where FCM token is stored
    // Example: Firestore.instance.collection('users').doc(userId).get();
    // Replace the following line with your actual logic
    // DocumentSnapshot userSnapshot = await Firestore.instance.collection('users').doc(userId).get();
    // fcmToken = userSnapshot.data()['fcmToken'];

    return fcmToken;
  }

  Future<String> _getUsername(String userId) async {
    // Implement logic to retrieve username
    // For demonstration purpose, return a hardcoded username
    // Replace this with your actual logic to retrieve username
    // Here's a dummy implementation
    return 'John Doe';
  }
}
