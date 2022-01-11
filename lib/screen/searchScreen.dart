import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/userProfile.dart';
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
      Provider.of<usersProvider>(context).setUsers().then((value) {
        screenLoading = false;
        init = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            height: displayHeight(context) * 0.06,
            width: displayWidth(context),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (user.dp.isEmpty)
                    ? CircleAvatar(
                        backgroundImage: AssetImage('images/male.jpg'),
                        radius: displayWidth(context) * 0.06,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(user.dp),
                        radius: displayWidth(context) * 0.06,
                      ),
                const VerticalDivider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: displayWidth(context) * 0.04),
                    ),
                    Text(
                      user.title,
                      style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.normal,
                          fontSize: displayWidth(context) * 0.038),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    final List<NexusUser> list =
        Provider.of<usersProvider>(context).fetchSearchList;
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: (screenLoading!)
            ? load(context)
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
                                    .where((element) =>
                                        (element.title.contains(value) ||
                                            element.username.contains(value)))
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
