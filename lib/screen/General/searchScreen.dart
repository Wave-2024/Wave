import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/ProfileDetails/userProfile.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class searchScreen extends StatefulWidget {
  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  bool? screenLoading;
  bool init = true;
  User? currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController? searchController;
  List<NexusUser> displayList = [];
  @override
  void initState() {
    screenLoading = true;
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    if (init) {
      Provider.of<manager>(context).setAllUsers().then((value) {
        init = false;
        screenLoading = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final List<NexusUser> list =
        Provider.of<manager>(context).fetchAllUsers.values.toList();
    Widget displayUserHeads(NexusUser user) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => userProfile(
                  uid: user.uid,
                ),
              ));
        },
          child: ListTile(
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    ))
      );
    }

    
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: (screenLoading!)
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: displayHeight(context)*0.2,),
            Expanded(child: Image.asset('images/searchLoad.gif')),
            Expanded(
              child: Text('Fetching Profiles',style: TextStyle(
                color: Colors.black54,fontSize: displayWidth(context)*0.05,
                fontWeight: FontWeight.bold
              ),),
            )
          ],
        )
            : SingleChildScrollView(
                child: (Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: displayHeight(context) * 0.08,
                      width: displayWidth(context),
                      //color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 20, right: 20),
                        child: Center(
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  displayList = [];
                                });
                              } else {
                                List<NexusUser> tempList = list
                                    .where((element) => (element.uid!=currentUser!.uid) &&
                                        (element.title.toLowerCase().contains(value.toLowerCase()) ||
                                            element.username.toLowerCase().contains(value.toLowerCase())))
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
                    ),
                    (displayList.isEmpty &&
                            searchController!.text.toString().isNotEmpty)
                        ? Center(
                            child: Text(
                              'No users found',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: displayWidth(context) * 0.045),
                            ),
                          )
                        : Container(
                            height: displayHeight(context) * 0.82,
                            width: displayWidth(context),
                            // color: Colors.pink,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, bottom: 16),
                              child: ListView.builder(
                                itemCount: displayList.length,
                                itemBuilder: (context, index) {
                                  return displayUserHeads(displayList[index]);
                                },
                              ),
                            ),
                          )
                  ],
                )),
              ),
      ),
    ));
  }
}
