import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Chat/inboxScreen.dart';
import 'package:nexus/screen/Posts/view/viewYourPosts.dart';
import 'package:nexus/screen/ProfileDetails/FollowersScreen.dart';
import 'package:nexus/screen/ProfileDetails/FollowingScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class userProfile extends StatefulWidget {
  final String? uid;
  userProfile({this.uid});
  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  bool? loadScreen;
  User? currentUser;
  bool loadAfterFollowProcess = false;
  bool init = true;
  bool? amIFollowing;
  bool blockingUserProcess = false;
  @override
  void initState() {
    loadScreen = true;
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      Provider.of<manager>(context)
          .setYourPosts(widget.uid.toString())
          .then((value) {
        loadScreen = false;
        init = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    NexusUser? thisProfile =
        Provider.of<manager>(context).fetchAllUsers[widget.uid.toString()];
    amIFollowing = thisProfile!.followers.contains(currentUser!.uid);
    List<PostModel> posts = Provider.of<manager>(context).fetchYourPostsList;
    bool haveIBlocked = Provider.of<manager>(context)
        .fetchAllUsers[currentUser!.uid]!
        .blocked
        .contains(widget.uid);

    bool haveTheyBlocked = Provider.of<manager>(context)
        .fetchAllUsers[widget.uid]!
        .blocked
        .contains(currentUser!.uid);

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.white,
          child: (loadScreen!)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: displayHeight(context) * 0.2,
                    ),
                    Expanded(
                        child: Image.asset(
                      'images/userProfileLoad.gif',
                      fit: BoxFit.cover,
                    )),
                    Expanded(
                      child: Text(
                        'Loading profile',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: displayWidth(context) * 0.05),
                      ),
                    ),
                  ],
                )
              : (blockingUserProcess)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.deepOrangeAccent,
                          backgroundColor: Colors.white,
                        ),
                        Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.04,
                            )),
                        const Text('Processing your request ...'),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: displayHeight(context) * 0.28,
                            width: displayWidth(context),
                            //color: Colors.pink,
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  top: 0,
                                  child: (thisProfile.coverImage != '')
                                      ? CachedNetworkImage(
                                          imageUrl: thisProfile.coverImage,
                                          height: displayHeight(context) * 0.25,
                                          width: displayWidth(context),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'images/cover.jpg',
                                          height: displayHeight(context) * 0.25,
                                          width: displayWidth(context),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Container(
                                  width: displayWidth(context),
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                        Colors.transparent,
                                        Colors.white
                                      ],
                                          stops: [
                                        0,
                                        .8
                                      ])),
                                ),
                                Positioned(
                                    top: displayHeight(context) * 0.1655,
                                    left: displayWidth(context) * 0.02,
                                    child: Card(
                                      elevation: 6.0,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.orange[600]!),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: (thisProfile.dp != '')
                                              ? CachedNetworkImage(
                                                  imageUrl: thisProfile.dp,
                                                  height:
                                                      displayHeight(context) *
                                                          0.0905,
                                                  width: displayWidth(context) *
                                                      0.175,
                                                  fit: BoxFit.cover,
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.orange[400],
                                                    size:
                                                        displayWidth(context) *
                                                            0.1,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    top: displayHeight(context) * 0.02,
                                    child: Text(
                                      thisProfile.title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              displayWidth(context) * 0.05,
                                          letterSpacing: 0.8),
                                    )),
                                Positioned(
                                    left: displayWidth(context) * 0.02,
                                    top: displayHeight(context) * 0.005,
                                    child: InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: Colors.white70,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.black54,
                                              size:
                                                  displayWidth(context) * 0.05,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    right: displayWidth(context) * 0.02,
                                    top: displayHeight(context) * 0.005,
                                    child: (haveTheyBlocked)
                                        ? const SizedBox()
                                        : InkWell(
                                            onTap: () {
                                              (haveIBlocked)
                                                  ? showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text(
                                                              'Unblock ${thisProfile.username} ?'),
                                                          actions: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                  child:
                                                                      TextButton(
                                                                child:
                                                                    const Text(
                                                                  'No',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black87),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              )),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                  child:
                                                                      TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    blockingUserProcess =
                                                                        true;
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                  await Provider.of<
                                                                              manager>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .unBlock(
                                                                          currentUser!
                                                                              .uid,
                                                                          widget
                                                                              .uid!);
                                                                  setState(() {
                                                                    blockingUserProcess =
                                                                        false;
                                                                  });
                                                                },
                                                                child: Text(
                                                                    'Yes',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green[800])),
                                                              )),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    )
                                                  : showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CupertinoAlertDialog(
                                                          title: Text(
                                                              'Block ${thisProfile.username} ?'),
                                                          actions: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Center(
                                                                  child:
                                                                      TextButton(
                                                                child:
                                                                    const Text(
                                                                  'No',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              )),
                                                            ),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Center(
                                                                  child:
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            setState(() {
                                                                              blockingUserProcess = true;
                                                                            });
                                                                            Navigator.pop(context);
                                                                            await Provider.of<manager>(context, listen: false).block(currentUser!.uid,
                                                                                widget.uid!);
                                                                            setState(() {
                                                                              blockingUserProcess = false;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Yes',
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, color: Colors.red[300]),
                                                                          )),
                                                                )),
                                                          ],
                                                        );
                                                      },
                                                    );
                                            },
                                            child: Card(
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              color: Colors.white70,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0,
                                                    bottom: 4,
                                                    left: 8,
                                                    right: 8),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        'images/block.png',
                                                        height: displayHeight(
                                                                context) *
                                                            0.028,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Text(
                                                          (haveIBlocked)?'Unblock':'Block',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize:
                                                                displayWidth(
                                                                        context) *
                                                                    0.023),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 1, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      thisProfile.username,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: displayWidth(context) * 0.045,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Opacity(
                                        opacity: 0.0,
                                        child: VerticalDivider(
                                          width: displayWidth(context) * 0.015,
                                        )),
                                    (thisProfile.followers.length >= 25)
                                        ? Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 1.5),
                                      child: Icon(
                                        Icons.verified,
                                        color: Colors.orange[400],
                                        size: displayWidth(context) * 0.048,
                                      ),
                                    )
                                        : const SizedBox(),
                                  ],
                                ),
                                Text(
                                  thisProfile.accountType,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: displayWidth(context) * 0.04,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.004,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 100),
                            child: (thisProfile.bio != '')
                                ? Container(
                              child: Text(
                                thisProfile.bio,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize:
                                    displayWidth(context) * 0.035),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                              ),
                            )
                                : const SizedBox(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 12),
                            child: InkWell(
                              onTap: ()async {
                                await openLink(thisProfile.linkInBio);
                              },
                              child: Text(thisProfile.linkInBio,style: TextStyle(
                                fontSize: displayWidth(context)*0.035,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo,
                              ),),
                            ),
                          ),
                          Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.005,
                            ),
                          ),
                          Container(
                            height: displayHeight(context) * 0.1,
                            width: displayWidth(context),
                            //color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    (haveIBlocked || haveTheyBlocked)
                                        ? (haveIBlocked)
                                            ? ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'You have blocked ${thisProfile.username}')))
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${thisProfile.username} has blocked you')))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowersScreen(
                                                      isThisMe: false,
                                                      allUsers:
                                                          Provider.of<manager>(
                                                                  context)
                                                              .fetchAllUsers,
                                                      followers: thisProfile
                                                          .followers),
                                            ));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        thisProfile.followers.length.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                displayWidth(context) * 0.04),
                                      ),
                                      Text(
                                        'Followers',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                displayWidth(context) * 0.036),
                                      )
                                    ],
                                  ),
                                )),
                                Expanded(
                                    child: InkWell(
                                  onTap: () {
                                    (haveIBlocked || haveTheyBlocked)
                                        ? (haveIBlocked)
                                            ? ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'You have blocked ${thisProfile.username}')))
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${thisProfile.username} has blocked you')))
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowingScreen(
                                                      allUsers:
                                                          Provider.of<manager>(
                                                                  context)
                                                              .fetchAllUsers,
                                                      following: thisProfile
                                                          .followings),
                                            ));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        thisProfile.followings.length
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                displayWidth(context) * 0.04),
                                      ),
                                      Text(
                                        'Following',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                displayWidth(context) * 0.036),
                                      ),
                                    ],
                                  ),
                                )),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      posts.length.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              displayWidth(context) * 0.04),
                                    ),
                                    Text(
                                      'Posts',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              displayWidth(context) * 0.036),
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.01,
                            ),
                          ),
                          Container(
                            height: displayHeight(context) * 0.08,
                            width: displayWidth(context),
                            //color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (haveIBlocked || haveTheyBlocked) {
                                      (haveIBlocked)
                                          ? ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'You have blocked ${thisProfile.username}')))
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      '${thisProfile.username} has blocked you')));
                                    } else {
                                      if (amIFollowing!) {
                                        setState(() {
                                          amIFollowing = !amIFollowing!;
                                        });
                                        Provider.of<manager>(context,
                                                listen: false)
                                            .unFollowUser(
                                                currentUser!.uid.toString(),
                                                thisProfile.uid);
                                      } else {
                                        setState(() {
                                          amIFollowing = !amIFollowing!;
                                        });
                                        Provider.of<manager>(context,
                                                listen: false)
                                            .followUser(
                                                currentUser!.uid.toString(),
                                                thisProfile.uid);
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: thisProfile.followers.contains(
                                                  currentUser!.uid.toString())
                                              ? Colors.grey[400]!
                                              : Colors.deepOrange),
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: amIFollowing!
                                              ? [Colors.white, Colors.white]
                                              : [
                                                  Colors.deepOrange,
                                                  Colors.deepOrangeAccent,
                                                  Colors.orange[600]!,
                                                ]),
                                    ),
                                    height: displayHeight(context) * 0.065,
                                    width: displayWidth(context) * 0.4,
                                    child: Center(
                                      child: (loadAfterFollowProcess)
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.black38,
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              amIFollowing!
                                                  ? 'Unfollow'
                                                  : 'Follow',
                                              style: TextStyle(
                                                  color: (amIFollowing!)
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      displayWidth(context) *
                                                          0.045),
                                            ),
                                    ),
                                  ),
                                ),
                                const Opacity(
                                    opacity: 0.0, child: VerticalDivider()),
                                (amIFollowing!)
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    inboxScreen(
                                                  yourUid: thisProfile.uid,
                                                  chatId:
                                                      generateChatRoomUsingUid(
                                                          thisProfile.uid,
                                                          currentUser!.uid),
                                                  myId: currentUser!.uid,
                                                ),
                                              ));
                                        },
                                        child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            color: Colors.white70,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Icon(
                                                Icons.mail_outline,
                                                size: displayWidth(context) *
                                                    0.05,
                                                color: Colors.black54,
                                              ),
                                            )),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          Opacity(
                              opacity: 0.0,
                              child: Divider(
                                height: displayHeight(context) * 0.01,
                              )),

                          (haveIBlocked || haveTheyBlocked)
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 50.0),
                                  child: Center(
                                      child: Text(
                                          'Posts are hidden at the moment')),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  //dragStartBehavior: DragStartBehavior.down,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemCount: posts.length,
                                  padding: const EdgeInsets.all(8),

                                  itemBuilder: (context, index) {
                                    var child;
                                    switch (posts[index].postType) {
                                      case "image":
                                        {
                                          child = CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: posts[index].image);
                                        }
                                        break;
                                      case "video":
                                        {
                                          child = Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: BorderSide(
                                                  color: Colors.black87,
                                                  width: displayWidth(context) *
                                                      0.001),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Image.asset(
                                                'images/video_prev.png',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          );
                                        }
                                        break;
                                      case "text":
                                        {
                                          child = Container(
                                            padding: EdgeInsets.all(25),
                                            child: Center(
                                                child: Text(
                                              posts[index].caption,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 8,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize:
                                                      displayWidth(context) *
                                                          0.022),
                                            )),
                                          );
                                        }
                                        break;
                                      default:
                                        {}
                                        break;
                                    }

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  viewYourPostsSceen(
                                                yourUid: thisProfile.uid,
                                                index: index,
                                                myUid: currentUser!.uid,
                                              ),
                                            ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: child),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
