import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/data/chat_data.dart';
import 'package:wave/models/chat_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/utils/util_functions.dart';

class ChatHeadContainer extends StatelessWidget {
  const ChatHeadContainer(
      {super.key,
      required this.chat,
      required this.otherUser,
      required this.seenLastMessage,
      required this.selfUser});
  final Chat chat;
  final User otherUser;
  final User selfUser;
  final bool seenLastMessage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -0.5),
      onTap: () async {
        Get.toNamed(AppRoutes.inboxScreen, arguments: {
          'chatId': chat.id,
          'otherUser': otherUser,
          'selfUser': selfUser
        });
      },
      subtitle: Text(
        ChatData.getDecryptedMessage(chat.lastMessage),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: CustomFont.poppins,
            fontSize: 12,
            // color: seenLastMessage ? Colors.black : Colors.black87,
            fontWeight: seenLastMessage ? FontWeight.normal : FontWeight.bold),
      ),
      trailing: seenLastMessage
          ? Text(
              timeAgo(chat.timeOfLastMessage),
              style: const TextStyle(
                color: Colors.green,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeAgo(chat.timeOfLastMessage),
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 10,
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                )
              ],
            ),
      leading: CircleAvatar(
        backgroundImage: (otherUser.displayPicture != null &&
                otherUser.displayPicture!.isNotEmpty)
            ? CachedNetworkImageProvider(otherUser.displayPicture!)
            : null,
        radius: 25,
        child: otherUser.displayPicture == null ||
                otherUser.displayPicture!.isEmpty
            ? const Icon(Icons.person)
            : null,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            otherUser.name,
            style: TextStyle(
                fontFamily: CustomFont.poppins,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1),
          ),
          const SizedBox(
            width: 2,
          ),
          Visibility(
              visible: otherUser.verified,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Image.asset(
                  CustomIcon.verifiedIcon,
                  height: 12.2,
                ),
              ))
        ],
      ),
    );
  }
}
