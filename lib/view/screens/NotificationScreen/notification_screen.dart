import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wave/data/notification_data.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/models/notification_model.dart' as not;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wave/view/reusable_components/notification_box.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            fontFamily: CustomFont.poppins,
            fontSize: 16.5,
            letterSpacing: -0.1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: CustomColor.primaryBackGround,
      ),
      body: StreamBuilder(
        stream: Database.getNotificationDatabase(
                FirebaseAuth.instance.currentUser!.uid)
            .orderBy('createdAt', descending: true)
            .limit(15)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> notificationSnap) {
          if ((notificationSnap.connectionState == ConnectionState.active ||
                  notificationSnap.connectionState == ConnectionState.done) &&
              notificationSnap.hasData) {
            if (notificationSnap.data!.docs.isEmpty) {
              return const SizedBox();
            } else {
              return ListView.builder(
                itemCount: notificationSnap.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    direction: Axis.horizontal,
                    enabled: true,
                    closeOnScroll: true,
                    dragStartBehavior: DragStartBehavior.down,
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) async {
                            CustomResponse customResponse =
                                await NotificationData.viewNotification(
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    notificationId:
                                        notificationSnap.data!.docs[index].id);
                            if (!customResponse.responseStatus) {
                              "${customResponse.response}".printError();
                            }
                          },
                          borderRadius: BorderRadius.circular(4),
                          backgroundColor: const Color(0xFF7BC043),
                          foregroundColor: Colors.white,
                          icon: AntDesign.check_circle_fill,
                          label: 'Read',
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        SlidableAction(
                          onPressed: (context) {},
                          borderRadius: BorderRadius.circular(4),
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          icon: AntDesign.delete_fill,
                          label: 'Delete',
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: NotificationBox(
                          notification: not.Notification.fromMap(
                              notificationSnap.data!.docs[index].data()!
                                  as Map<String, dynamic>)),
                    ),
                  );
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColor.primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
}
