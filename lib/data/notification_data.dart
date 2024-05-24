import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/models/notification_model.dart' as notification;

class NotificationData {
  static Future<notification.Notification> getNotification(
      String userId, String notificationId) async {
    var res = await Database.getNotificationDatabase(userId)
        .doc(notificationId)
        .get();
    return notification.Notification.fromMap(
        res.data()! as Map<String, dynamic>);
  }

  static Future<CustomResponse> createNotification(
      {required notification.Notification notification}) async {
    try {
      var response =
          await Database.getNotificationDatabase(notification.forUser)
              .add(notification.toMap());
      await Database.getNotificationDatabase(notification.forUser)
          .doc(response.id)
          .update({'id': response.id});
      return CustomResponse(responseStatus: true);
    } on FirebaseException catch (e) {
      return CustomResponse(responseStatus: false, response: e.message!);
    }
  }
}
