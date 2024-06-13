import 'package:wave/data/post_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/services/notification_service.dart';

class CustomNotificationService {
  static Future<void> sendNotificationForComment(
      {required String postId,
      required String comment,
      required String myUserId}) async {
    Post post = await PostData.getPost(postId);
    User otherUser = await UserData.getUser(userID: post.userId);
    User me = await UserData.getUser(userID: myUserId);
    await NotificationService.sendPushNotification(
      fcmToken: otherUser.fcmToken,
      message: "${me.name} commented on your post : $comment",
      title: "You received a new comment",
    );
  }

  static Future<void> sendNotificationForMessage({
    required String message,
    required User otherUser,
    required User me,
    required String chatId,
  }) async {
    await NotificationService.sendPushNotification(
        fcmToken: otherUser.fcmToken,
        message: "${me.name}: $message",
        title: "You received a new message",
        data: {
          'chatId': chatId,
          'otherUserId': otherUser.id,
          'selfUserId' : me.id
        });
  }
}
