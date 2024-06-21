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
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/reusable_components/custom_textbox_for_comment.dart';
import 'package:wave/view/reusable_components/message_container.dart';
import 'package:wave/view/screens/ChatScreen/more_options_message.dart';

class InboxScreen extends StatelessWidget {
   InboxScreen({
    super.key,
  });

  User otherUser = Get.arguments['otherUser'];

  User selfUser = Get.arguments['selfUser'];

  String chatId = Get.arguments['chatId'];

  TextEditingController messageController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
      backgroundColor: CustomColor.primaryBackGround,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryBackGround,
        leadingWidth: Get.width * 0.1,
        title: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.profileScreen, arguments: otherUser.id);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: (otherUser.displayPicture != null &&
                        otherUser.displayPicture!.isNotEmpty)
                    ? CachedNetworkImageProvider(otherUser.displayPicture!)
                    : null,
                radius: 20,
                child: otherUser.displayPicture == null ||
                        otherUser.displayPicture!.isEmpty
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
                    otherUser.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: CustomFont.poppins),
                  ),
                  Text(
                    otherUser.username,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontFamily: CustomFont.poppins),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(AntDesign.more_outline))
        ],
      ),
      body: CustomTextBoxForComments(
        commentController: messageController,
        sendWidget: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Bootstrap.send_plus)),
        labelText: "Message",
        sendButtonMethod: () async {
          if (messageController.text.trim().isNotEmpty) {
            messageController.text.length.printInfo();
            Message message = Message(
                message: messageController.text.trim(),
                sender: selfUser.id,
                createdAt: DateTime.now(),
                message_type: MESSAGE_TYPE.TEXT,
                id: 'id',
                chatId: chatId);
            CustomResponse customResponse = await ChatData.sendMessage(
                message, selfUser.id, otherUser.id);
            if (customResponse.responseStatus) {
              CustomNotificationService.sendNotificationForMessage(
                  otherUser: otherUser,
                  me: selfUser,
                  message: message.message,
                  chatId: chatId);
            } else {
              log(customResponse.response.toString());
            }
            messageController.clear();
          }
        },
        imageUrl: selfUser.displayPicture,
        child: StreamBuilder(

          stream: Database.chatDatabase
              .doc(chatId)
              .collection('messages')
              .orderBy('createdAt', descending: true)
              .limit(50)
              .snapshots(),

          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> messageSnap) {

            if(messageSnap.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else if(messageSnap.connectionState == ConnectionState.active ||
                messageSnap.connectionState == ConnectionState.done){

              if(messageSnap.hasData){
                Message lastMessage = Message.fromMap(
                    messageSnap.data!.docs.first.data()
                    as Map<String, dynamic>);
                if(lastMessage.sender!=selfUser.id && !lastMessage.seen){
                  ChatData.markLastMessageAsRead(chatId);
                }
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onLongPress: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return MoreOptionsForMessage(
                                    message: message,
                                    firstUser: selfUser.id,
                                    secondUser: otherUser.id,
                                  );
                                },
                              );
                            },
                            child: MessageContainer(
                                currentUser: selfUser,
                                sender: message.sender == selfUser.id
                                    ? selfUser
                                    : otherUser,
                                message: message),
                          ),
                          Visibility(
                              visible:
                              (index == 0 &&
                                  message.sender == selfUser.id &&
                                  message.seen),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Image.asset(
                                    CustomIcon.doubleCheckIcon,
                                    height: 15,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    );
                  },
                );
              }
              else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        CustomIcon.emptyIcon,
                        height: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "No messages to display",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: CustomFont.poppins),
                    )
                  ],
                );
              }

            }
            else{
              return SizedBox();
            }


          },
        ),
      ),
    );
  }
}



