import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/chat_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/reusable_components/chat_head_container.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserDataController>(
        builder: (context, userDataController, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Chats",
                  style: TextStyle(
                      fontFamily: CustomFont.poppins,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () => Get.toNamed(AppRoutes.searchToChatScreen),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        width: double.infinity,
                        height: displayHeight(context) * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.blue.shade100.withOpacity(0.25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.search,
                              color: Colors.black54,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Search",
                              style: TextStyle(
                                  fontFamily: CustomFont.poppins,
                                  color: Colors.black54,
                                  fontSize: 14),
                            ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Database.userDatabase
                        .doc(userDataController.user!.id)
                        .collection('chats')
                        .orderBy('timeOfLastMessage', descending: true)
                        .limit(20)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> chatSnaps) {
                      if ((chatSnaps.connectionState ==
                                  ConnectionState.active ||
                              chatSnaps.connectionState ==
                                  ConnectionState.done) &&
                          chatSnaps.hasData) {
                        return ListView.builder(
                          itemCount: chatSnaps.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Chat chat = Chat.fromMap(chatSnaps.data!.docs[index]
                                .data() as Map<String, dynamic>);
                            String otherUserId =
                                chat.firstUser == userDataController.user!.id
                                    ? chat.secondUser
                                    : chat.firstUser;
                            return FutureBuilder<User>(
                              future: UserData.getUser(userID: otherUserId),
                              builder: (BuildContext context,
                                  AsyncSnapshot<User> otherUserSnap) {
                                if (otherUserSnap.connectionState ==
                                        ConnectionState.done &&
                                    otherUserSnap.hasData) {
                                  return ChatHeadContainer(
                                      chat: chat,
                                      selfUser: userDataController.user!,
                                      otherUser: otherUserSnap.data!);
                                }
                                return const SizedBox();
                              },
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
