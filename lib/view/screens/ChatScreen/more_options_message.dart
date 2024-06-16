import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wave/data/chat_data.dart';
import 'package:wave/models/message_model.dart';
import 'package:wave/utils/constants/custom_fonts.dart';

class MoreOptionsForMessage extends StatelessWidget {
  final Message message;
  final String firstUser;
  final String secondUser;
  const MoreOptionsForMessage(
      {super.key,
      required this.message,
      required this.firstUser,
      required this.secondUser});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Wrap(
      children: [
        Visibility(
          visible: message.sender == FirebaseAuth.instance.currentUser!.uid,
          child: ListTile(
            leading: const Icon(AntDesign.edit_outline),
            title: Text('Edit',
                style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
            onTap: () {
              // TODO : Edit Message
            },
          ),
        ),
        Visibility(
          visible: message.sender == FirebaseAuth.instance.currentUser!.uid,
          child: ListTile(
            leading: const Icon(AntDesign.delete_fill),
            title: Text('Delete',
                style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    title: Text(
                      "Unsend Message?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: CustomFont.inter,
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to delete this message ? The message will be deleted from both the devices and cannot be retreived.",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontFamily: CustomFont.poppins),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontFamily: CustomFont.poppins,
                                color: Colors.black87),
                          )),
                      TextButton(
                          onPressed: () async {
                            ChatData.unsendMessage(
                                message, firstUser, secondUser);
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(
                                fontFamily: CustomFont.poppins,
                                color: Colors.red),
                          ))
                    ],
                  );
                },
              );
            },
          ),
        ),
        ListTile(
          leading: const Icon(AntDesign.block_outline),
          title: Text('Report',
              style: TextStyle(fontFamily: CustomFont.poppins, fontSize: 14)),
          onTap: () {
            // TODO : Report Message
          },
        ),
      ],
    ));
  }
}
