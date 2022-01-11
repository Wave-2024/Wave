import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:provider/provider.dart';

import 'devicesize.dart';

Widget displayPosts(
    BuildContext context, PostModel post, Map<String, dynamic> mapOfUsers) {
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: (user.dp != '')
                            ? CachedNetworkImage(
                                imageUrl: user.dp,
                                height: displayHeight(context) * 0.075,
                                width: displayWidth(context) * 0.175,
                              )
                            : Image.asset(
                                'images/male.jpg',
                                height: displayHeight(context) * 0.075,
                                width: displayWidth(context) * 0.175,
                              ),
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
                  height: displayHeight(context) * 0.022,
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: post.image,
                    height: displayHeight(context) * 0.42,
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
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: displayWidth(context) * 0.04,
                            child: Center(
                              child: Image.asset(
                                'images/like.png',
                                height: displayHeight(context) * 0.035,
                              ),
                            ),
                          ),
                          const Opacity(opacity: 0.0, child: VerticalDivider()),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: displayWidth(context) * 0.04,
                            child: Center(
                              child: Image.asset(
                                'images/comment.png',
                                height: displayHeight(context) * 0.035,
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
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  post.likes.length.toString() + ' likes',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: displayWidth(context) * 0.035,
                      fontWeight: FontWeight.bold),
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
