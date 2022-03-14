import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class blockedUsersScreen extends StatelessWidget {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var allUsers = Provider.of<manager>(context).fetchAllUsers;
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
    return ListTile(
        leading: (widget.user!.dp != '')
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider((widget.user!.dp)),
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
              widget.user!.username,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: displayWidth(context) * 0.035),
            ),
            Opacity(
                opacity: 0.0,
                child: VerticalDivider(
                  width: displayWidth(context) * 0.003,
                )),
            (widget.user!.followers.length >= 25)
                ? Icon(
                    Icons.verified,
                    color: Colors.orange[400],
                    size: displayWidth(context) * 0.048,
                  )
                : const SizedBox(),
          ],
        ),
        title: Text(
          widget.user!.title,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: displayWidth(context) * 0.038),
        ),
        trailing: (isProcessing)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.teal,
                  backgroundColor: Colors.white,
                  value: displayWidth(context) * 0.01,
                ),
              )
            : InkWell(
                splashColor: Colors.orange,
                onTap: () async {
                  if (isProcessing) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Please wait , processing previous request')));
                  } else {
                    setState(() {
                      isProcessing = true;
                    });
                    await Provider.of<manager>(context, listen: false)
                        .unBlock(currentUser!.uid, widget.user!.uid);
                    setState(() {
                      isProcessing = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Unblocked ${widget.user!.username}"),

                    ));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.orange)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Unblock',
                      style: TextStyle(fontSize: displayWidth(context) * 0.03),
                    ),
                  ),
                )));
  }
}
