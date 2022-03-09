import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:provider/provider.dart';

class blockedUsersScreen extends StatelessWidget {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var allUsers = Provider.of<manager>(context, listen: false).fetchAllUsers;
    List<dynamic> blockedUsersUid = allUsers[currentUser!.uid]!.blocked;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Blocked Users',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: ListView.builder(
          itemCount: blockedUsersUid.length,
          itemBuilder: (context, index) {
            NexusUser user = allUsers[blockedUsersUid[index]]!;
            return listTileForBlockedUser(
              user: user,
            );
          },
        ),
      ),
    );
  }
}

// TODO: Implement this class to display a list-tile

class listTileForBlockedUser extends StatefulWidget {
  final NexusUser? user;
  listTileForBlockedUser({this.user});

  @override
  State<listTileForBlockedUser> createState() => _listTileForBlockedUserState();
}

class _listTileForBlockedUserState extends State<listTileForBlockedUser> {
  bool isProcessing = false;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    // Properties of list tile would be
    // leading - Circleavatar displaying dp
    // subtitle - title of user
    // title - username of user
    // trailing - unblock
    return ListTile();
  }
}

// Only for testing purpose !!

// Take reference from this method
/*
ListTile(
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

*/
