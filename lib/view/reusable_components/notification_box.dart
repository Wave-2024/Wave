import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wave/data/post_data.dart';
import 'package:wave/data/users_data.dart';
import 'package:wave/models/notification_model.dart' as not;
import 'package:wave/models/post_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/util_functions.dart';

class NotificationBox extends StatelessWidget {
  not.Notification notification;
  NotificationBox({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    switch (notification.type) {
      case 'comment':
        return FutureBuilder<User>(
          future: UserData.getUser(userID: notification.userWhoCommented!),
          builder: (BuildContext context, AsyncSnapshot<User> userSnap) {
            if (userSnap.connectionState == ConnectionState.done &&
                userSnap.hasData) {
              final timeOfComment = calculateTimeAgo(notification.createdAt);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: (userSnap.data!.displayPicture != null &&
                          userSnap.data!.displayPicture!.isNotEmpty)
                      ? CachedNetworkImageProvider(
                          userSnap.data!.displayPicture!)
                      : null,
                  radius: 20,
                  child: userSnap.data!.displayPicture == null ||
                          userSnap.data!.displayPicture!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: userSnap.data!.name, // The name
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomFont.poppins,
                          color: Colors.blue, // Change to your desired color
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: ' commented on your post', // The rest of the text
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: CustomFont.poppins,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.comment!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: CustomFont.poppins,
                            fontSize: 12,
                            color: Colors.grey.shade800),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                          '${timeago.format(timeOfComment, locale: 'en_short')} ago',
                          style: TextStyle(
                              fontFamily: CustomFont.poppins,
                              fontSize: 10,
                              color: Colors.red.shade700)),
                    ],
                  ),
                ),
                trailing: FutureBuilder<Post>(
                  future: PostData.getPost(notification.postId!),
                  builder:
                      (BuildContext context, AsyncSnapshot<Post> postSnap) {
                    if (postSnap.connectionState == ConnectionState.done &&
                        postSnap.hasData) {
                      if (postSnap.data!.postList.isEmpty) {
                        return SizedBox();
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: postSnap.data!.postList.first.url,
                            width: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Container(
                                height: 30,
                                width: 50,
                                color: Colors.red.shade100,
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
            }
            return const SizedBox();
          },
        );
      case 'like':
        return FutureBuilder<User>(
          future: UserData.getUser(userID: notification.userWhoLiked!),
          builder: (BuildContext context, AsyncSnapshot<User> userSnap) {
            if (userSnap.connectionState == ConnectionState.done &&
                userSnap.hasData) {
              final timeOfComment = calculateTimeAgo(notification.createdAt);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: (userSnap.data!.displayPicture != null &&
                          userSnap.data!.displayPicture!.isNotEmpty)
                      ? CachedNetworkImageProvider(
                          userSnap.data!.displayPicture!)
                      : null,
                  radius: 20,
                  child: userSnap.data!.displayPicture == null ||
                          userSnap.data!.displayPicture!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: userSnap.data!.name, // The name
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomFont.poppins,
                          color: Colors.blue, // Change to your desired color
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: ' liked your post', // The rest of the text
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: CustomFont.poppins,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                      '${timeago.format(timeOfComment, locale: 'en_short')} ago',
                      style: TextStyle(
                          fontFamily: CustomFont.poppins,
                          fontSize: 10,
                          color: Colors.red.shade700)),
                ),
                trailing: FutureBuilder<Post>(
                  future: PostData.getPost(notification.postId!),
                  builder:
                      (BuildContext context, AsyncSnapshot<Post> postSnap) {
                    if (postSnap.connectionState == ConnectionState.done &&
                        postSnap.hasData) {
                      if (postSnap.data!.postList.isEmpty) {
                        return SizedBox();
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: postSnap.data!.postList.first.url,
                            width: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Container(
                                height: 30,
                                width: 50,
                                color: Colors.red.shade100,
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
            }
            return const SizedBox();
          },
        );
      case 'mention':
        return Container();
      case 'follow':
        return FutureBuilder<User>(
          future: UserData.getUser(userID: notification.userWhoFollowed!),
          builder: (BuildContext context, AsyncSnapshot<User> userSnap) {
            if (userSnap.connectionState == ConnectionState.done &&
                userSnap.hasData) {
              final timeOfComment = calculateTimeAgo(notification.createdAt);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: (userSnap.data!.displayPicture != null &&
                          userSnap.data!.displayPicture!.isNotEmpty)
                      ? CachedNetworkImageProvider(
                          userSnap.data!.displayPicture!)
                      : null,
                  radius: 20,
                  child: userSnap.data!.displayPicture == null ||
                          userSnap.data!.displayPicture!.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: userSnap.data!.name, // The name
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: CustomFont.poppins,
                          color: Colors.blue, // Change to your desired color
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: ' started following you', // The rest of the text
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: CustomFont.poppins,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Say Hi to your new follower !",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: CustomFont.poppins,
                            fontSize: 12,
                            color: Colors.grey.shade800),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                          '${timeago.format(timeOfComment, locale: 'en_short')} ago',
                          style: TextStyle(
                              fontFamily: CustomFont.poppins,
                              fontSize: 10,
                              color: Colors.red.shade700)),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        );
      case 'reply':
        return Container();
      default:
        return Container();
    }
  }
}
