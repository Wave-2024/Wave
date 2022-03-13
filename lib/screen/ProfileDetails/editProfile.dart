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
  TextEditingController? accountTypeController;
  TextEditingController? bioController;
  bool? isEditing;
  bool init = true;
  TextEditingController? linkInBioController;
  bool? isScreenLoading;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    linkInBioController = TextEditingController(text: widget.user!.linkInBio);
    titleController = TextEditingController(text: widget.user!.title);
    userNameController = TextEditingController(text: widget.user!.username);
    bioController = TextEditingController(text: widget.user!.bio);
    accountTypeController =
        TextEditingController(text: widget.user!.accountType);
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
    accountTypeController!.dispose();
    linkInBioController!.dispose();
    titleController!.dispose();
    userNameController!.dispose();
    bioController!.dispose();
  }

  setAccountType(String accountType) {
    setState(() {
      accountTypeController = TextEditingController(text: accountType);
    });
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
                        TextFormField(
                          controller: linkInBioController,
                          validator: (link) {
                            if (link!.isEmpty) {
                              return null;
                            } else {
                              bool _valid = Uri.parse(link).isAbsolute;
                              if (!_valid) {
                                return 'Please enter valid URL';
                              } else {
                                return null;
                              }
                            }
                          },
                          decoration: const InputDecoration(
                              labelText: "Link",
                              labelStyle: TextStyle(color: Colors.black54)),
                        ),
                        const Opacity(opacity: 0.0, child: Divider()),
                        TextFormField(
                          controller: accountTypeController,
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Social');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Social')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Business');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Business')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Celebrity');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Celebrity')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Sports');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Sports')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Developer');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Developer')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('News');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('News')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Music');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Music')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Dance');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Dance')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Meme');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Meme')),
                                          TextButton(
                                              onPressed: () {
                                                setAccountType('Gaming');
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Gaming')),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          readOnly: true,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                color: Colors.indigo,
                              ),
                              labelText: "Account Type",
                              labelStyle: TextStyle(color: Colors.black54)),
                        ),
                        Opacity(
                            opacity: 0.0,
                            child: Divider(
                              height: displayHeight(context) * 0.03,
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
                                accountTypeController!.text.toString(),
                                linkInBioController!.text.toString(),
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
