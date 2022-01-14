import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus/models/CommentModel.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/postDetailScreen.dart';
import 'package:provider/provider.dart';
import 'devicesize.dart';

Widget displayPosts(BuildContext context, PostModel post,
    Map<String, dynamic> mapOfUsers, String myUid, List<String> months) {
  DateTime dateTime = DateFormat('d/MM/yyyy').parse(post.dateOfPost);
  String day = dateTime.day.toString();
  String year = dateTime.year.toString();
  String month = months[dateTime.month - 1];
  NexusUser user = mapOfUsers[post.uid];
  return Container(
    height: displayHeight(context) * 0.7,
    width: displayWidth(context),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Colors.grey[200],
    ),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        height: displayHeight(context) * 0.65,
        width: displayWidth(context) * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (user.dp != '')
                          ? CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: displayWidth(context) * 0.06,
                              backgroundImage: NetworkImage(user.dp),
                            )
                          : CircleAvatar(
                              radius: displayWidth(context) * 0.06,
                              backgroundImage: AssetImage('images/male.jpg'),
                            ),
                      const VerticalDivider(),
                      Text(
                        user.username,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: displayWidth(context) * 0.042,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.chat))
                ],
              ),
              Opacity(
                opacity: 0.0,
                child: Divider(
                  height: displayHeight(context) * 0.02,
                ),
              ),
              Center(
                child: Container(
                    height: displayHeight(context) * 0.03,
                    width: displayWidth(context) * 0.68,
                    //color: Colors.redAccent,
                    child: Text(
                      post.caption,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w600),
                    )),
              ),
              Opacity(
                opacity: 0.0,
                child: Divider(
                  height: displayHeight(context) * 0.02,
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: post.image,
                    height: displayHeight(context) * 0.38,
                    width: displayWidth(context) * 0.68,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Container(
                  height: displayHeight(context) * 0.075,
                  width: displayWidth(context) * 0.8,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (post.likes.contains(myUid)) {
                                Provider.of<usersProvider>(context,
                                        listen: false)
                                    .disLikeThisPost(
                                        myUid, post.uid, post.post_id);
                              } else {
                                Provider.of<usersProvider>(context,
                                        listen: false)
                                    .likeThisPost(
                                        myUid, post.uid, post.post_id);
                              }
                            },
                            child: (post.likes.contains(myUid))
                                ? CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: displayWidth(context) * 0.04,
                                    child: Center(
                                      child: Image.asset(
                                        'images/like.png',
                                        height: displayHeight(context) * 0.035,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: displayWidth(context) * 0.04,
                                    child: Center(
                                      child: Image.asset(
                                        'images/like_out.png',
                                        height: displayHeight(context) * 0.035,
                                      ),
                                    ),
                                  ),
                          ),
                          const Opacity(opacity: 0.0, child: VerticalDivider()),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => postDetailScreen(
                                      user_who_posted: user,
                                      postId: post.post_id,
                                    ),
                                  ));
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: displayWidth(context) * 0.04,
                              child: Center(
                                child: Image.asset(
                                  'images/comment.png',
                                  height: displayHeight(context) * 0.035,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: displayWidth(context) * 0.04,
                        child: Center(
                          child: Image.asset(
                            'images/bookmark.png',
                            height: displayHeight(context) * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.likes.length.toString() + ' likes',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: displayWidth(context) * 0.035,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${day} ${month} ${year}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: displayWidth(context) * 0.033,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

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
RichText printComment(BuildContext context,String userName, String comment) {
  return RichText(
      text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
                text: userName,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            TextSpan(
                text: ': ' + comment,
                style: const TextStyle(
                    color: Colors.black,

                ))
          ]));
}

String? generateChatRoomUsingUid(String uid1,String uid2){
  String? chatRoom;
  if(uid1.compareTo(uid2)<0){
    chatRoom = uid1+uid2;
  }
  else{
    chatRoom = uid2+uid1;
  }
  return chatRoom;
}

Widget displayComment(BuildContext context,CommentModel commentModel) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Card(
        color: Colors.white,
        elevation: 12.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              height: displayHeight(context)*0.05,
              width: displayWidth(context)*0.1,
              fit: BoxFit.cover,
              imageUrl: commentModel.userDp,
            ),
      ),
        ),),
      Opacity(opacity: 0.0,child: VerticalDivider(width: displayWidth(context)*0.02,)),
      Flexible(
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: printComment(context, commentModel.userName, commentModel.comment),
          ),
        ),
      )
    ],
  );
}
