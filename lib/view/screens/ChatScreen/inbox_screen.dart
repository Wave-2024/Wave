import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wave/data/chat_data.dart';
import 'package:wave/models/message_model.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/services/custom_notification_service.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/view/reusable_components/custom_textbox_for_comment.dart';
import 'package:wave/view/reusable_components/message_container.dart';
import 'package:wave/view/screens/ChatScreen/more_options_message.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({
    super.key,
  });

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String? chatId;
  User? otherUser;
  User? selfUser;

  TextEditingController? messageController;
  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    otherUser = Get.arguments['otherUser'];
    selfUser = Get.arguments['selfUser'];
    chatId = Get.arguments['chatId'];
  }

  @override
  void dispose() {
    messageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryBackGround,
        leadingWidth: displayWidth(context) * 0.1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: (otherUser!.displayPicture != null &&
                      otherUser!.displayPicture!.isNotEmpty)
                  ? CachedNetworkImageProvider(otherUser!.displayPicture!)
                  : null,
              radius: 20,
              child: otherUser!.displayPicture == null ||
                      otherUser!.displayPicture!.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherUser!.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: CustomFont.poppins),
                ),
                Text(
                  otherUser!.username,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontFamily: CustomFont.poppins),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(AntDesign.more_outline))
        ],
      ),
      body: CustomTextBoxForComments(
        commentController: messageController,
        sendWidget: const Icon(Bootstrap.send_plus),
        labelText: "Message",
        sendButtonMethod: () async {
          if (messageController!.text.trim().isNotEmpty) {
            messageController!.text.length.printInfo();
            Message message = Message(
                message: messageController!.text.trim(),
                sender: selfUser!.id,
                createdAt: DateTime.now(),
                message_type: MESSAGE_TYPE.TEXT,
                id: 'id',
                chatId: chatId!);
            CustomResponse customResponse = await ChatData.sendMessage(
                message, selfUser!.id, otherUser!.id);
            if (customResponse.responseStatus) {
              CustomNotificationService.sendNotificationForMessage(
                  otherUser: otherUser!,
                  me: selfUser!,
                  message: message.message,
                  chatId: chatId!);
            } else {
              log(customResponse.response.toString());
            }
            messageController!.clear();
          }
        },
        imageUrl: selfUser!.displayPicture,
        child: StreamBuilder(
          stream: Database.chatDatabase
              .doc(chatId!)
              .collection('messages')
              .orderBy('createdAt', descending: true)
              .limit(50)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> messageSnap) {
            if ((messageSnap.connectionState == ConnectionState.active ||
                    messageSnap.connectionState == ConnectionState.done) &&
                messageSnap.hasData) {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                reverse: true,
                itemCount: messageSnap.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  Message message = Message.fromMap(
                      messageSnap.data!.docs[index].data()
                          as Map<String, dynamic>);
                  message = message.copyWith(
                      message: ChatData.getDecryptedMessage(message.message));
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      onLongPress: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return MoreOptionsForMessage(
                              message: message,
                              firstUser: selfUser!.id,
                              secondUser: otherUser!.id,
                            );
                          },
                        );
                      },
                      child: MessageContainer(
                          currentUser: selfUser!,
                          sender: message.sender == selfUser!.id
                              ? selfUser!
                              : otherUser!,
                          message: message),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
