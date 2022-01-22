import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Posts/detail/postDetailForMyPost.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class viewPostsFromProfile extends StatefulWidget {
  final String? uid;
  final bool? viewPosts;
  viewPostsFromProfile({this.uid, this.viewPosts});

  @override
  State<viewPostsFromProfile> createState() => _viewPostsFromProfileState();
}

class _viewPostsFromProfileState extends State<viewPostsFromProfile> {
  User? currentUser;
  bool? init;
  bool? screenLoading;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  void initState() {
    init = true;
    screenLoading = true;
    currentUser = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (init!) {
      Provider.of<usersProvider>(context)
          .setPostsForThisProfile(widget.uid.toString())
          .then((value) {
        init = false;
        screenLoading = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, PostModel> savedPosts =
        Provider.of<usersProvider>(context).fetchSavedPosts;
    final Map<String, PostModel> postsForThisUser =
        Provider.of<usersProvider>(context).fetchThisUserPosts;
    final Map<String, NexusUser> allUsers =
        Provider.of<usersProvider>(context).fetchAllUsers;

    // Display post of this user
    Widget displayPostsForThisUser(BuildContext context, PostModel post,
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
            height: displayHeight(context) * 0.66,
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
                                  backgroundColor: Colors.grey[200],
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.orange[300],
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
                      IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
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
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Divider(
                      height: displayHeight(context) * 0.02,
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onDoubleTap: () {
                        if (post.likes.contains(myUid)) {
                          Provider.of<usersProvider>(context, listen: false)
                              .disLikePostFromThisUserProfile(
                                  myUid, post.uid, post.post_id);
                        } else {
                          Provider.of<usersProvider>(context, listen: false)
                              .likeThisPostFromThisUserProfile(
                                  myUid, post.uid, post.post_id);
                        }
                      },
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
                                        .disLikePostFromThisUserProfile(
                                            myUid, post.uid, post.post_id);
                                  } else {
                                    Provider.of<usersProvider>(context,
                                            listen: false)
                                        .likeThisPostFromThisUserProfile(
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
                                            height:
                                                displayHeight(context) * 0.035,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: displayWidth(context) * 0.04,
                                        child: Center(
                                          child: Image.asset(
                                            'images/like_out.png',
                                            height:
                                                displayHeight(context) * 0.035,
                                          ),
                                        ),
                                      ),
                              ),
                              const Opacity(
                                  opacity: 0.0, child: VerticalDivider()),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            postDetailForMyPosts(
                                          postOwner: user,
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
                            child: GestureDetector(
                              onTap: () {
                                if (savedPosts.containsKey(post.post_id)) {
                                  Provider.of<usersProvider>(context,
                                          listen: false)
                                      .unsavePost(post.post_id, myUid);
                                } else {
                                  Provider.of<usersProvider>(context,
                                          listen: false)
                                      .savePost(post, myUid);
                                }
                              },
                              child: Center(
                                child: (savedPosts.containsKey(post.post_id))
                                    ? Image.asset(
                                        'images/bookmark.png',
                                        height: displayHeight(context) * 0.035,
                                      )
                                    : Image.asset(
                                        'images/bookmark_out.png',
                                        height: displayHeight(context) * 0.035,
                                      ),
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

    Widget displaySavedForThisUser(
      BuildContext context,
      PostModel post,
      Map<String, dynamic> mapOfUsers,
      String myUid,
      List<String> months,
    ) {
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
            height: displayHeight(context) * 0.66,
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
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.orange[300],
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
                      IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
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
                              color: Colors.black87,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Divider(
                      height: displayHeight(context) * 0.02,
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onDoubleTap: () {
                        if (post.likes.contains(myUid)) {
                          Provider.of<usersProvider>(context, listen: false)
                              .disLikePostFromSavedPosts(
                                  myUid, post.uid, post.post_id);
                        } else {
                          Provider.of<usersProvider>(context, listen: false)
                              .likeThisPostFromSavedPosts(
                                  myUid, post.uid, post.post_id);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: CachedNetworkImage(
                          imageUrl: post.image,
                          height: displayHeight(context) * 0.38,
                          width: displayWidth(context) * 0.68,
                          fit: BoxFit.contain,
                        ),
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
                                        .disLikePostFromSavedPosts(
                                            myUid, post.uid, post.post_id);
                                  } else {
                                    Provider.of<usersProvider>(context,
                                            listen: false)
                                        .likeThisPostFromSavedPosts(
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
                                            height:
                                                displayHeight(context) * 0.035,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: displayWidth(context) * 0.04,
                                        child: Center(
                                          child: Image.asset(
                                            'images/like_out.png',
                                            height:
                                                displayHeight(context) * 0.035,
                                          ),
                                        ),
                                      ),
                              ),
                              const Opacity(
                                  opacity: 0.0, child: VerticalDivider()),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            postDetailForMyPosts(
                                          postOwner: user,
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
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<usersProvider>(context,
                                        listen: false)
                                    .unsavePost(post.post_id, myUid);
                              },
                              child: Center(
                                child: (savedPosts.containsKey(post.post_id))
                                    ? Image.asset(
                                        'images/bookmark.png',
                                        height: displayHeight(context) * 0.035,
                                      )
                                    : Image.asset(
                                        'images/bookmark_out.png',
                                        height: displayHeight(context) * 0.035,
                                      ),
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        child: (screenLoading!)
            ? Center(
                child: load(context),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 21.0, right: 21, top: 10),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return (widget.viewPosts!)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: displayPostsForThisUser(
                              context,
                              postsForThisUser.values.toList()[index],
                              allUsers,
                              currentUser!.uid.toString(),
                              months,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: displaySavedForThisUser(
                              context,
                              savedPosts.values.toList()[index],
                              allUsers,
                              currentUser!.uid.toString(),
                              months,
                            ),
                          );
                  },
                  itemCount: (widget.viewPosts!)
                      ? postsForThisUser.length
                      : savedPosts.length,
                )),
      ),
    );
  }
}
