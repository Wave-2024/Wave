import 'package:wave/data/post_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/services/notification_service.dart';

class CommentNotificationService {
  static Future<void> sendNotification(
      {required String postId,
      required String comment,
      required String myUserId}) async {
    Post post = await PostData.getPost(postId);
    User otherUser = await UserData.getUser(userID: post.userId);
    User me = await UserData.getUser(userID: myUserId);
    await NotificationService.sendPushNotification(
      fcmToken: otherUser.fcmToken,
      message: "${me.name} commented on your post : ${comment}",
      title: "You received a new comment",
    );
  }
}
