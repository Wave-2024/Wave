import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus/models/CommentModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/ProfileDetails/userProfile.dart';
import 'package:provider/provider.dart';
import 'devicesize.dart';




Widget load(BuildContext context) {
  return const Center(
    child: CircularProgressIndicator(
      color: Colors.orange,
      backgroundColor: Colors.blue,
    ),
  );
}

Widget loadInsideButton(BuildContext context) {
  return const Center(
    child: CircularProgressIndicator(
      color: Colors.white,
      backgroundColor: Colors.white30,
    ),
  );
}

RichText printComment(BuildContext context, String userName, String comment) {
  return RichText(
      text: TextSpan(style: TextStyle(color: Colors.black), children: [
    TextSpan(
        text: userName,
        style:
            TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: displayWidth(context) * 0.035,
      ),
    ),
          
    TextSpan(
        text: ': ' + comment,
        style: TextStyle(
          color: Colors.black,
          fontSize: displayWidth(context) * 0.035,
        ))
  ]));
}

String? generateChatRoomUsingUid(String uid1, String uid2) {
  String? chatRoom;
  if (uid1.compareTo(uid2) < 0) {
    chatRoom = uid1 + uid2;
  } else {
    chatRoom = uid2 + uid1;
  }
  return chatRoom;
}

Widget displayComment(BuildContext context, String comment, String uid) {
  NexusUser? user =
      Provider.of<usersProvider>(context, listen: false).fetchAllUsers[uid];
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Card(
        color: Colors.white,
        elevation: 12.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(2.5),
          child: (user!.dp != '')
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: displayHeight(context) * 0.042,
                    width: displayWidth(context) * 0.078,
                    fit: BoxFit.cover,
                    imageUrl: user.dp,
                  ),
                )
              : Icon(
                  Icons.person,
                  color: Colors.orange[300],
                  size: displayWidth(context) * 0.076,
                ),
        ),
      ),
      Icon(
        Icons.verified,
        color: Colors.orange[400],
        size: displayWidth(context) * 0.044,
      ),
      
      Opacity(
          opacity: 0.0,
          child: VerticalDivider(
            width: displayWidth(context) * 0.01,
          )),
      Flexible(
        child: Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: printComment(context, user.username, comment),
          ),
        ),
      )
    ],
  );
}

int findDifferenc(int a, int b) {
  return (a - b).abs();
}

String differenceOfTime(DateTime current, DateTime lastSeen) {
  String diff = '';
  if (findDifferenc(current.year, lastSeen.year) == 0) {
    // same year
    if (findDifferenc(current.month, lastSeen.month) == 0) {
      // same month
      if (findDifferenc(current.day, lastSeen.day) == 0) {
        // Same day
        if (findDifferenc(current.hour, lastSeen.hour) == 0) {
          // Same hour
          if (findDifferenc(current.minute, lastSeen.minute) == 0) {
            // Same minute
            if (findDifferenc(current.second, lastSeen.second) == 0) {
              return 'last talked just now';
            } else {
              diff = findDifferenc(current.second, lastSeen.second).toString() +
                  ' seconds';
            }
          } else {
            diff = findDifferenc(current.minute, lastSeen.minute).toString() +
                ' minutes';
          }
        } else {
          diff =
              findDifferenc(current.hour, lastSeen.hour).toString() + ' hours';
        }
      } else {
        diff = findDifferenc(current.day, lastSeen.day).toString() + ' days';
      }
    } else {
      diff =
          findDifferenc(current.month, lastSeen.month).toString() + ' months';
    }
  } else {
    diff = findDifferenc(current.year, lastSeen.year).toString() + ' year';
  }
  return 'last talked ${diff} ago';
}

void sendMessage(String chatId, String message, String uid) async {
  Timestamp time = Timestamp.now();
  await FirebaseFirestore.instance.collection(chatId).doc().set({
    'message': message,
    'time': time,
    'uid': uid,
  });
  await FirebaseFirestore.instance
      .collection(uid)
      .doc(chatId)
      .update({'lastSent': time});
}

Widget messageContainer(
    String message, String uid, String dp, String myUid, BuildContext context) {
  return (uid == myUid)
      ? Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: displayWidth(context)*0.7),
                decoration: BoxDecoration(
                
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.black87,
                    letterSpacing: 0.08,
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
            Card(
              color: Colors.white,
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    height: displayHeight(context) * 0.0365,
                    width: displayWidth(context) * 0.075,
                    fit: BoxFit.cover,
                    imageUrl: dp,
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              width: 1.8,
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
                        Colors.deepOrange,
                        Colors.deepOrangeAccent,
                        Colors.orange[600]!,
                      ]),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  message,
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

Widget displayProfileHeads(BuildContext context, NexusUser user) {
  return ListTile(
      tileColor: Colors.transparent,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => userProfile(
                uid: user.uid,
              ),
            ));
      },
      title: Text(
        user.title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.username,
        style: TextStyle(color: Colors.black45),
      ),
      leading: (user.dp != '')
          ? CircleAvatar(
              backgroundImage: NetworkImage(user.dp),
              radius: displayWidth(context) * 0.05,
            )
          : CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: displayWidth(context) * 0.05,
              child: Icon(
                Icons.person,
                size: displayWidth(context) * 0.075,
                color: Colors.orange[400],
              ),
            ));
}
