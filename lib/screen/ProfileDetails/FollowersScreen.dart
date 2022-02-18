import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/ProfileDetails/userProfile.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

class FollowersScreen extends StatefulWidget {
  bool isThisMe;
  List<dynamic> followers;
  Map<String, NexusUser> allUsers;
  FollowersScreen({required this.followers, required this.allUsers,required this.isThisMe});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  List<NexusUser> displayList = [];
  List<NexusUser> primaryList = [];
  bool processing = false;
  TextEditingController? searchController;
  User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    createMyFollowersList();
    searchController = TextEditingController();
  }

  createMyFollowersList() {
    for (var element in widget.followers) {
      NexusUser user = widget.allUsers[element]!;
      primaryList.add(user);
    }
    displayList = primaryList;
  }

  searchBox() {
    return Container(
      height: displayHeight(context) * 0.08,
      width: displayWidth(context),
      //color: Colors.red,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 10, right: 10),
        child: Center(
          child: TextFormField(
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  displayList = primaryList;
                });
              } else {
                List<NexusUser> tempList = primaryList
                    .where((element) =>
                        (element.uid != currentUser!.uid) &&
                        (element.title
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            element.username
                                .toLowerCase()
                                .contains(value.toLowerCase())))
                    .toList();
                setState(() {
                  displayList = tempList;
                });
              }
            },
            controller: searchController,
            decoration: const InputDecoration(
              prefixIconColor: Colors.orange,
              suffixIcon: Icon(
                Icons.person,
                color: Colors.black45,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.orange,
              ),
              hintText: "Search",
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Followers',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        height: displayHeight(context),
        width: displayWidth(context),
        child: (processing) ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            const CircularProgressIndicator(
              color: Colors.deepOrangeAccent,
              backgroundColor: Colors.white,
            ),
            Opacity(opacity: 0.0,child: Divider(height: displayHeight(context)*0.04,)),
            const Text('Processing your request ...'),
          ],
        )
            :

        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              searchBox(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      if (displayList[index].uid != currentUser!.uid) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  userProfile(uid: displayList[index].uid),
                            ));
                      }
                    },
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -3),
                    leading: (displayList[index].dp != '')
                        ? CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                displayList[index].dp),
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
                          ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          displayList[index].username,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: displayWidth(context) * 0.035),
                        ),
                        Opacity(
                            opacity: 0.0,
                            child: VerticalDivider(
                              width: displayWidth(context) * 0.003,
                            )),
                        (displayList[index].followers.length >= 25)
                            ? Icon(
                                Icons.verified,
                                color: Colors.orange[400],
                                size: displayWidth(context) * 0.048,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    title: Text(
                      displayList[index].title,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.038),
                    ),
                    trailing:  (widget.isThisMe)? InkWell(
                        splashColor: Colors.orange,
                        onTap: () async {
                          if(processing){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please wait , processing previous request')));
                          }
                          else{
                            setState(() {
                              processing = true;
                            });
                            await Provider.of<manager>(context,listen: false).unFollowUser(widget.followers[index],currentUser!.uid);
                            setState(() {
                              primaryList.removeAt(index);
                              processing = false;
                            });

                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.orange)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Remove',style: TextStyle(fontSize: displayWidth(context)*0.03),),
                          ),
                        )
                    ):const SizedBox()
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
