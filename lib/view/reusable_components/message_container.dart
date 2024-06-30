import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/models/message_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';

import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/routing.dart';

class MessageContainer extends StatelessWidget {
  Message message;
  User sender, currentUser;
  MessageContainer(
      {super.key,
      required this.currentUser,
      required this.sender,
      required this.message});

  final double fontsize = 14;

  @override
  Widget build(BuildContext context) {
    return (sender.id == currentUser.id)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: displayWidth(context) * 0.7),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: CustomFont.inter,
                          fontSize: fontsize,
                        ),
                      ),
                      Wrap(
                        textDirection: TextDirection.rtl,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            '${message.createdAt.hour}:${message.createdAt.minute}',
                            style: const TextStyle(
                                fontSize: 8,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.profileScreen, arguments: sender.id);
                },
                child: CircleAvatar(
                  backgroundImage: (sender.displayPicture != null &&
                          sender.displayPicture!.isNotEmpty)
                      ? CachedNetworkImageProvider(sender.displayPicture!)
                      : null,
                  child: sender.displayPicture == null ||
                          sender.displayPicture!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Flexible(
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: displayWidth(context) * 0.7),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: CustomFont.inter,
                          fontSize: fontsize,
                        ),
                      ),
                      Wrap(
                        textDirection: TextDirection.rtl,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          Text(
                            '${message.createdAt.hour}:${message.createdAt.minute}',
                            style: const TextStyle(
                                fontSize: 8,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
