import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexus/models/PostModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Posts/view/viewMyPostsScreen.dart';
import 'package:nexus/screen/Posts/view/viewMySavedPosts.dart';
import 'package:nexus/screen/ProfileDetails/FollowersScreen.dart';
import 'package:nexus/screen/ProfileDetails/FollowingScreen.dart';
import 'package:nexus/screen/ProfileDetails/editProfile.dart';
import 'package:nexus/services/AuthService.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Authentication/authscreen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class profiletScreen extends StatefulWidget {
  @override
  State<profiletScreen> createState() => _profiletScreenState();
}

class _profiletScreenState extends State<profiletScreen> {
  final authservice _auth = authservice(FirebaseAuth.instance);
  bool viewPosts = true;
  File? imagefile;
  final picker = ImagePicker();
  bool? loadScreenForProfile;
  bool? loadScreenForEdititng;
  User? currentUser;
  bool init = true;
  ScrollController? controller = ScrollController();
  final Future<SharedPreferences> localStoreInstance =
      SharedPreferences.getInstance();
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    loadScreenForEdititng = false;
    loadScreenForProfile = false;
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      await Provider.of<manager>(context).updateMyProfile(currentUser!.uid);
      final SharedPreferences localStore = await localStoreInstance;
      if (!localStore.getBool('myPosts')!) {
        loadScreenForProfile = true;
        await Provider.of<manager>(context, listen: false)
            .setMyPosts(currentUser!.uid);
        localStore.setBool('myPosts', true);
        loadScreenForProfile = false;
      }
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<File> checkAnCompress() async {
    File? compressedFile = imagefile!;
    int minimumSize = 200 * 1024;
    if (await compressedFile.length() > minimumSize) {
      final dir = await path_provider.getTemporaryDirectory();
      final tp = dir.absolute.path + "/temp.jpg";
      compressedFile = await compressAndGetFile(compressedFile, tp);
    }
    return compressedFile;
  }

  @override
  Widget build(BuildContext context) {
    NexusUser? myProfile = Provider.of<manager>(context)
        .fetchAllUsers[currentUser!.uid.toString()];
    List<PostModel> posts = Provider.of<manager>(context).fetchMyPostsList;

    Map<String, PostModel>? savedPosts =
        Provider.of<manager>(context).fetchSavedPostsMap;
    Future pickImageForCoverPicture() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (mounted) {
        if (pickedFile != null) {
          setState(() {
            loadScreenForEdititng = true;
            imagefile = File(pickedFile.path);
          });
          File? compressedFile = await checkAnCompress();
          setState(() {
            imagefile = compressedFile;
          });
          await Provider.of<manager>(context, listen: false)
              .addCoverPicture(imagefile, currentUser!.uid.toString())
              .then((value) {
            setState(() {
              loadScreenForEdititng = false;
            });
          });
        }
      }
    }

    Future pickImageForProfilePicture() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (mounted) {
        if (pickedFile != null) {
          setState(() {
            loadScreenForEdititng = true;
            imagefile = File(pickedFile.path);
          });
          File? compressedFile = await checkAnCompress();
          setState(() {
            imagefile = compressedFile;
          });
          await Provider.of<manager>(context, listen: false)
              .addProfilePicture(imagefile, currentUser!.uid.toString())
              .then((value) {
            setState(() {
              loadScreenForEdititng = false;
            });
          });
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: displayHeight(context),
          width: displayWidth(context),
          color: Colors.white,
          child: (loadScreenForProfile! || loadScreenForEdititng!)
              ? (loadScreenForProfile!)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: displayHeight(context) * 0.2,
                        ),
                        Expanded(
                            child: Image.asset('images/updateProfile.gif')),
                        Expanded(
                            child: Text(
                          'Fetching your details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: displayWidth(context) * 0.05),
                        )),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: displayHeight(context) * 0.2,
                        ),
                        Expanded(child: Image.asset('images/uploadPost.gif')),
                        Expanded(
                          child: Text(
                            'Uploading image',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: displayWidth(context) * 0.05),
                          ),
                        ),
                      ],
                    )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SingleChildScrollView(
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
                                child: (myProfile!.coverImage != '')
                                    ? CachedNetworkImage(
                                        imageUrl: myProfile.coverImage,
                                        height: displayHeight(context) * 0.25,
                                        width: displayWidth(context),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'images/cover.jpg',
                                        height: displayHeight(context) * 0.25,
                                        width: displayWidth(context),
                                        fit: BoxFit.fill,
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
                                      .85
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
                                        borderRadius: BorderRadius.circular(12),
                                        child: (myProfile.dp != '')
                                            ? CachedNetworkImage(
                                                imageUrl: myProfile.dp,
                                                height: displayHeight(context) *
                                                    0.0905,
                                                width: displayWidth(context) *
                                                    0.175,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                Icons.person,
                                                color: Colors.orange[400],
                                                size: displayWidth(context) *
                                                    0.175,
                                              ),
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  top: displayHeight(context) * 0.075,
                                  right: displayWidth(context) * 0.02,
                                  child: IconButton(
                                    iconSize: displayWidth(context) * 0.075,
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height:
                                                displayHeight(context) * 0.18,
                                            width: displayWidth(context),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ListTile(
                                                  onTap: () async {
                                                    pickImageForCoverPicture()
                                                        .then((value) =>
                                                            Navigator.pop(
                                                                context));
                                                  },
                                                  tileColor: Colors.white,
                                                  title: Text(
                                                    'Change Cover Picture',
                                                    style: TextStyle(
                                                        fontSize: displayWidth(
                                                                context) *
                                                            0.05,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                ListTile(
                                                  tileColor: Colors.white,
                                                  onTap: () async {
                                                    pickImageForProfilePicture()
                                                        .then((value) =>
                                                            Navigator.pop(
                                                                context));
                                                  },
                                                  title: Text(
                                                    'Change Profile Picture',
                                                    style: TextStyle(
                                                        fontSize: displayWidth(
                                                                context) *
                                                            0.05,
                                                        color: Colors.black45,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    color: Colors.white70,
                                    icon: Icon(Icons.add_a_photo),
                                  )),
                              Positioned(
                                  top: displayHeight(context) * 0.15,
                                  right: displayWidth(context) * 0.02,
                                  child: IconButton(
                                    iconSize: displayWidth(context) * 0.08,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                editProfileScreen(
                                              user: myProfile,
                                            ),
                                          ));
                                    },
                                    color: Colors.white70,
                                    icon: const Icon(Icons.edit),
                                  )),
                              Positioned(
                                  top: displayHeight(context) * 0.02,
                                  child: Text(
                                    myProfile.title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: displayWidth(context) * 0.05,
                                        letterSpacing: 0.8),
                                  )),
                              Positioned(
                                  right: displayWidth(context) * 0.02,
                                  top: displayHeight(context) * 0.005,
                                  child: IconButton(
                                    iconSize: displayWidth(context) * 0.08,
                                    icon: const Icon(Icons.logout),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            //content: Text('Are you sure you want to sign-out ?'),
                                            title: const Text('Logout'),
                                            actions: [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: TextButton(
                                                  child: const Text(
                                                    'No',
                                                    style: TextStyle(
                                                        color: Colors.black87),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: TextButton.icon(
                                                  onPressed: () async {
                                                    _auth
                                                        .signOut()
                                                        .then((value) {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const authScreen(),
                                                          ));
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.logout,
                                                    color: Colors.red,
                                                  ),
                                                  label: const Text('Yes',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87)),
                                                )),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    color: Colors.white70,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                myProfile.username,
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
                              (myProfile.followers.length >= 25)
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 1.5),
                                      child: Icon(
                                        Icons.verified,
                                        color: Colors.orange[400],
                                        size: displayWidth(context) * 0.048,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: 0.0,
                          child: Divider(
                            height: displayHeight(context) * 0.008,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0,right: 12),
                          child: (myProfile.bio != '')
                              ? Container(
                                  child: Text(
                                    myProfile.bio,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: displayWidth(context)*0.035
                                    ),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                  ),
                                )
                              : const SizedBox(),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FollowersScreen(
                                          isThisMe: true,
                                            allUsers:
                                                Provider.of<manager>(context)
                                                    .fetchAllUsers,
                                            followers: myProfile.followers),
                                      ));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      myProfile.followers.length.toString(),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FollowingScreen(
                                            allUsers:
                                                Provider.of<manager>(context)
                                                    .fetchAllUsers,
                                            following: myProfile.followings),
                                      ));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      myProfile.followings.length.toString(),
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
                                        fontSize: displayWidth(context) * 0.04),
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
                        const Opacity(
                          opacity: 0.0,
                          child: Divider(
                            height: 2,
                          ),
                        ),
                        Center(
                          child: Container(
                            height: displayHeight(context) * 0.08,
                            width: displayWidth(context) * 0.66,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (!viewPosts) {
                                          viewPosts = !viewPosts;
                                        }
                                      });
                                    },
                                    child: (viewPosts)
                                        ? Card(
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0,
                                                  right: 30,
                                                  top: 8,
                                                  bottom: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Posts',
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: displayWidth(
                                                                context) *
                                                            0.042,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Opacity(
                                                      opacity: 0.0,
                                                      child: VerticalDivider(
                                                        width: displayWidth(
                                                                context) *
                                                            0.01,
                                                      )),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white54,
                                                    radius:
                                                        displayWidth(context) *
                                                            0.03,
                                                    child: Text(
                                                      posts.length.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize:
                                                              displayWidth(
                                                                      context) *
                                                                  0.03),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Posts',
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize:
                                                        displayWidth(context) *
                                                            0.042,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Opacity(
                                                  opacity: 0.0,
                                                  child: VerticalDivider(
                                                    width:
                                                        displayWidth(context) *
                                                            0.01,
                                                  )),
                                              CircleAvatar(
                                                backgroundColor: Colors.white38,
                                                radius: displayWidth(context) *
                                                    0.03,
                                                child: Text(
                                                  posts.length.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: displayWidth(
                                                              context) *
                                                          0.03),
                                                ),
                                              )
                                            ],
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (viewPosts) {
                                          viewPosts = !viewPosts;
                                        }
                                      });
                                    },
                                    child: (!viewPosts)
                                        ? Card(
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 30.0,
                                                    right: 30,
                                                    top: 8,
                                                    bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Saved',
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize:
                                                              displayWidth(
                                                                      context) *
                                                                  0.042,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Opacity(
                                                        opacity: 0.0,
                                                        child: VerticalDivider(
                                                          width: displayWidth(
                                                                  context) *
                                                              0.01,
                                                        )),
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white54,
                                                      radius: displayWidth(
                                                              context) *
                                                          0.03,
                                                      child: Text(
                                                        savedPosts.length
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize:
                                                                displayWidth(
                                                                        context) *
                                                                    0.03),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Saved',
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize:
                                                        displayWidth(context) *
                                                            0.042,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Opacity(
                                                  opacity: 0.0,
                                                  child: VerticalDivider(
                                                    width:
                                                        displayWidth(context) *
                                                            0.01,
                                                  )),
                                              CircleAvatar(
                                                backgroundColor: Colors.white38,
                                                radius: displayWidth(context) *
                                                    0.03,
                                                child: Text(
                                                  savedPosts.length.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: displayWidth(
                                                              context) *
                                                          0.03),
                                                ),
                                              )
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.01,
                            )),
                        GridView.builder(
                          controller: controller,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          //dragStartBehavior: DragStartBehavior.down,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount:
                              (viewPosts) ? posts.length : savedPosts.length,
                          padding: const EdgeInsets.all(8),

                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: (viewPosts)
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      viewMyPostScreen(
                                                    myUid: myProfile.uid,
                                                    index: index,
                                                  ),
                                                ));
                                          },
                                          child: CachedNetworkImage(
                                              height:
                                                  displayHeight(context) * 0.1,
                                              width:
                                                  displayWidth(context) * 0.3,
                                              fit: BoxFit.cover,
                                              imageUrl: posts[index].image),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      viewMySavedPostScreen(
                                                    myUid: myProfile.uid,
                                                    index: index,
                                                  ),
                                                ));
                                          },
                                          child: CachedNetworkImage(
                                              height:
                                                  displayHeight(context) * 0.1,
                                              width:
                                                  displayWidth(context) * 0.3,
                                              fit: BoxFit.cover,
                                              imageUrl: savedPosts.values
                                                  .toList()[index]
                                                  .image),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
