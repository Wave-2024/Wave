import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/providers/usernameProvider.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class editProfileScreen extends StatefulWidget {
  NexusUser? user;

  editProfileScreen({this.user});

  @override
  State<editProfileScreen> createState() => _editProfileScreenState();
}

class _editProfileScreenState extends State<editProfileScreen> {
  TextEditingController? titleController;
  TextEditingController? userNameController;
  TextEditingController? bioController;
  bool? isEditing;
  bool init = true;
  bool? isScreenLoading;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    titleController = TextEditingController(text: widget.user!.title);
    userNameController = TextEditingController(text: widget.user!.username);
    bioController = TextEditingController(text: widget.user!.bio);
    isEditing = false;
    isScreenLoading = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      Provider.of<usernameProvider>(context).setUserNames().then((value) {
        isScreenLoading = false;
        init = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController!.dispose();
    userNameController!.dispose();
    bioController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, bool>? listOfUserNames =
        Provider.of<usernameProvider>(context).fetchUserNames;

    final Map<String, NexusUser> allUsers =
        Provider.of<manager>(context).fetchAllUsers;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (isScreenLoading!)
              ? load(context)
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Cannot be empty';
                            }
                          },
                          controller: titleController,
                          decoration: const InputDecoration(
                              labelText: "Full Name",
                              labelStyle: TextStyle(color: Colors.black54)),
                        ),
                        const Opacity(opacity: 0.0, child: Divider()),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Cannot be empty';
                            } else if (listOfUserNames!.containsKey(value) &&
                                allUsers[widget.user!.uid]!.username != value) {
                              return 'User name already taken';
                            } else {
                              return null;
                            }
                          },
                          controller: userNameController,
                          decoration: const InputDecoration(
                              labelText: "User Name",
                              labelStyle: TextStyle(color: Colors.black54)),
                        ),
                        const Opacity(opacity: 0.0, child: Divider()),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          maxLength: 120,
                          maxLines: 5,
                          minLines: 1,
                          controller: bioController,
                          decoration: const InputDecoration(
                              labelText: "Bio",
                              labelStyle: TextStyle(color: Colors.black54)),
                        ),
                        Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.05,
                            )),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isEditing = true;
                              });
                              Provider.of<manager>(context, listen: false)
                                  .editMyProfile(
                                      FirebaseAuth.instance.currentUser!.uid
                                          .toString(),
                                      titleController!.text.toString(),
                                      userNameController!.text.toString(),
                                      bioController!.text.toString(),
                                'type',
                                'link'
                              )
                                  .then((value) {
                                setState(() {
                                  isEditing = false;
                                });
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Container(
                            height: displayHeight(context) * 0.07,
                            width: displayWidth(context) * 0.6,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.deepOrange,
                                    Colors.deepOrangeAccent,
                                    Colors.orange[600]!,
                                  ]),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: (isEditing!)
                                ? loadInsideButton(context)
                                : Center(
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              displayWidth(context) * 0.04),
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
