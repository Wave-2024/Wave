import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/view/reusable_components/textbox_editprofile.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    User user = Get.arguments as User;
    "Entered Edit Profile Screen with User ${user.name}".printInfo();
    nameController = TextEditingController(text: user.name);
    bioController = TextEditingController(text: user.bio);
    userNameController = TextEditingController(text: user.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.primaryBackGround,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColor.primaryBackGround,
          centerTitle: true,
          title: Text(
            "Edit Profile",
            style: TextStyle(
                fontSize: 16.5,
                letterSpacing: -0.1,
                fontFamily: CustomFont.poppins,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          iconTheme: const IconThemeData(color: Colors.black54),
        ),
        body: Consumer<UserDataController>(
          builder: (context, userDataController, child) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: displayHeight(context) * 0.3,
                        width: double.infinity,
                        // color: Colors.red.shade100,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          fit: StackFit.loose,
                          children: [
                            (userDataController.user!.coverPicture.isNotEmpty)
                                ? CachedNetworkImage(
                                    imageUrl:
                                        userDataController.user!.coverPicture,
                                    height: displayHeight(context) * 0.22,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    CustomLogo.logo,
                                    height: displayHeight(context) * 0.22,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                            Positioned(
                              bottom: 0,
                              child: CircleAvatar(
                                // Bigger radius avatar
                                radius: displayWidth(context) * 0.162,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  // Image avatar
                                  radius: displayWidth(context) * 0.15,
                                  backgroundImage: (userDataController
                                                  .user!.displayPicture !=
                                              null &&
                                          userDataController
                                              .user!.displayPicture!.isNotEmpty)
                                      ? CachedNetworkImageProvider(
                                          userDataController
                                              .user!.displayPicture!)
                                      : const AssetImage("assets/logo/logo.png")
                                          as ImageProvider,
                                ),
                              ),
                            ),
                            Positioned(
                                right: 10,
                                bottom: displayHeight(context) * 0.06,
                                child: InkWell(
                                  onTap: () {
                                    "Changing Cover Picture".printInfo();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 15,
                                    child: Image.asset(
                                      CustomIcon.changeImageIcon,
                                      color: CustomColor.primaryColor,
                                      height: 22,
                                    ),
                                  ),
                                )),
                            Positioned(
                              right: displayWidth(context) * 0.29,
                              bottom: displayHeight(context) * 0.016,
                              child: InkWell(
                                onTap: () {
                                  "Changing Display Picture".printInfo();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 15,
                                  child: Image.asset(
                                    CustomIcon.changeImageIcon,
                                    color: CustomColor.primaryColor,
                                    height: 22,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.05,
                      ),
                      TextBoxForEditProfile(
                        controller: nameController,
                        label: "Full Name",
                        // prefixIcon: Icon(Icons.person_2),
                        uniqueKey: "editName",
                        visible: true,
                        maxLength: 25,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name cannnot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextBoxForEditProfile(
                        controller: userNameController,
                        label: "Username",
                        // prefixIcon: Icon(Icons.person_2),
                        uniqueKey: "editUserName",
                        visible: true,
                        maxLength: 25,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username cannnot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextBoxForEditProfile(
                        controller: bioController,
                        label: "Update Bio",
                        // prefixIcon: Icon(Icons.person_2),
                        uniqueKey: "editBio",
                        visible: true,
                        maxLength: 125,
                        maxLines: 3,
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(
                        height: displayHeight(context) * 0.04,
                      ),
                      SizedBox(
                        width: displayWidth(context) * 0.6,
                        child: MaterialButton(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          height: displayHeight(context) * 0.06,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              CustomResponse customResponse =
                                  await userDataController.updateProfile(
                                      bio: bioController.text.trim(),
                                      name: nameController.text.trim(),
                                      username: userNameController.text.trim());
                              String message =
                                  customResponse.response.toString();

                              if (customResponse.responseStatus) {
                                Get.showSnackbar(const GetSnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                  borderRadius: 5,
                                  title: "Success !!",
                                  message: "Your profile has been updated",
                                ));
                              } else {
                                Get.showSnackbar(const GetSnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                  borderRadius: 5,
                                  title: "Something went wrong !!",
                                ));
                              }
                            }
                          },
                          color: CustomColor.primaryColor,
                          child: Text(
                            "Update Profile",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: CustomFont.poppins,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
