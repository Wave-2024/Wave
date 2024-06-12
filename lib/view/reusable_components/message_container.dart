import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wave/models/message_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';

import 'package:wave/utils/device_size.dart';

class MessageContainer extends StatelessWidget {
  Message message;
  User sender, currentUser;
  MessageContainer(
      {super.key,
      required this.currentUser,
      required this.sender,
      required this.message});

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
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: Colors.black87,
                      letterSpacing: 0.08,
                      fontFamily: CustomFont.inter,
                      fontSize: displayWidth(context) * 0.038,
                    ),
                  ),
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: (sender.displayPicture != null &&
                        sender.displayPicture!.isNotEmpty)
                    ? CachedNetworkImageProvider(sender.displayPicture!)
                    : null,
                child: sender.displayPicture == null ||
                        sender.displayPicture!.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              SizedBox(
                width: 4,
              ),
              Flexible(
                child: Container(
                  constraints:
                      BoxConstraints(maxWidth: displayWidth(context) * 0.7),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xfb2193b0),
                          Color(0xfb6dd5ed)
                          // Colors.orange[600]!,
                        ]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: displayWidth(context) * 0.036,
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
