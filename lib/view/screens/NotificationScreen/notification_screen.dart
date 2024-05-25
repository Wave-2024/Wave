import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/models/notification_model.dart' as not;
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
              return SizedBox();
            } else {
              return ListView.builder(
                itemCount: notificationSnap.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return NotificationBox(
                      notification: not.Notification.fromMap(
                          notificationSnap.data!.docs[index].data()!
                              as Map<String, dynamic>));
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
