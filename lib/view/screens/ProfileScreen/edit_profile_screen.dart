import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/constants/cutom_logo.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/image_config.dart';
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
  CroppedFile? croppedImageForCoverPhoto;
  CroppedFile? croppedImageForDisplayPicture;
  Timer? debounce;
  late User user;
  bool foundUniqueUsername = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    user = Get.arguments as User;
    "Entered Edit Profile Screen with User ${user.name}".printInfo();
    nameController = TextEditingController(text: user.name);
    bioController = TextEditingController(text: user.bio);
    userNameController = TextEditingController(text: user.username);
    userNameController.addListener(isUsernameUnique);
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  Future<void> isUsernameUnique() async {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 800), () async {
      final QuerySnapshot result = await Database.userDatabase
          .where('username', isEqualTo: userNameController.text)
          .get();
      printInfo(info: "Searching for: ${userNameController.text}");
      final List<DocumentSnapshot> documents = result.docs;
      foundUniqueUsername = documents.isEmpty;
      setState(() {});
    });
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
                            (croppedImageForCoverPhoto != null)
                                ? Image.file(
                                    File(croppedImageForCoverPhoto!.path),
                                    height: displayHeight(context) * 0.22,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : (userDataController
                                        .user!.coverPicture.isNotEmpty)
                                    ? CachedNetworkImage(
                                        imageUrl: userDataController
                                            .user!.coverPicture,
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
                                  backgroundImage:
                                      (croppedImageForDisplayPicture != null)
                                          ? FileImage(File(
                                              croppedImageForDisplayPicture!
                                                  .path))
                                          : (userDataController.user!
                                                          .displayPicture !=
                                                      null &&
                                                  userDataController
                                                      .user!
                                                      .displayPicture!
                                                      .isNotEmpty)
                                              ? CachedNetworkImageProvider(
                                                  userDataController
                                                      .user!.displayPicture!)
                                              : const AssetImage(
                                                      "assets/logo/logo.png")
                                                  as ImageProvider,
                                ),
                              ),
                            ),
                            Positioned(
                                right: 10,
                                bottom: displayHeight(context) * 0.06,
                                child: InkWell(
                                  onTap: () async {
                                    XFile? pickedImage =
                                        await pickImage(context);
                                    "Changing Cover Picture".printInfo();
                                    if (pickedImage != null) {
                                      croppedImageForCoverPhoto =
                                          await cropImage(
                                        File(
                                          pickedImage.path,
                                        ),
                                        list: [
                                          CropAspectRatioPreset.ratio16x9,
                                          CropAspectRatioPreset.ratio3x2
                                        ],
                                      );
                                      if (croppedImageForCoverPhoto != null) {
                                        setState(() {});
                                      }
                                    }
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
                                onTap: () async {
                                  "Changing Display Picture".printInfo();
                                  XFile? pickedImage = await pickImage(context);

                                  if (pickedImage != null) {
                                    croppedImageForDisplayPicture =
                                        await cropImage(
                                      cropStyle: CropStyle.circle,
                                      File(
                                        pickedImage.path,
                                      ),
                                    );
                                    if (croppedImageForDisplayPicture != null) {
                                      setState(() {});
                                    }
                                  }
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
                        suffixIcon: (user.username != userNameController.text)
                            ? foundUniqueUsername
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 16,
                                  )
                                : Icon(
                                    Icons.close,
                                    size: 16,
                                    color: CustomColor.errorColor,
                                  )
                            : null,
                        onChanged: (p0) => isUsernameUnique(),
                        controller: userNameController,
                        label: "Username",
                        // prefixIcon: Icon(Icons.person_2),
                        uniqueKey: "editUserName",
                        visible: true,
                        maxLines: 1,

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
                              bool isUsernameChanged =
                                  user.username != userNameController.text;
                              bool canUpdateProfile =
                                  !isUsernameChanged || foundUniqueUsername;
                              String successMessage =
                                  "Your profile has been updated successfully.";
                              String errorMessage = isUsernameChanged
                                  ? "The username you entered is already in use. Please choose another."
                                  : "An unexpected error occurred. Please try again later.";

                              if (canUpdateProfile) {
                                StreamSubscription<CustomResponse>? sub;
                                sub = userDataController
                                    .updateProfile(
                                  bio: bioController.text.trim(),
                                  name: nameController.text.trim(),
                                  username: userNameController.text.trim(),
                                  displayPicture: croppedImageForDisplayPicture,
                                  coverPicture: croppedImageForCoverPhoto,
                                )
                                    .listen(
                                  (CustomResponse response) {
                                    if (response.responseStatus) {
                                      Get.showSnackbar(GetSnackBar(
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                        borderRadius: 5,
                                        title: "Success",
                                        message: successMessage,
                                      ));
                                    } else {
                                      Get.showSnackbar(GetSnackBar(
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                        borderRadius: 5,
                                        title: "Error",
                                        message: response.response ??
                                            "Something went wrong. Please try again.",
                                      ));
                                    }
                                  },
                                  onError: (error) {
                                    Get.showSnackbar(GetSnackBar(
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                      borderRadius: 5,
                                      title: "Error",
                                      message: errorMessage,
                                    ));
                                  },
                                  onDone: () {
                                    // Cleanup if necessary when stream is done
                                    sub?.cancel();
                                    setState(() {
                                      user = user.copyWith(
                                          name: nameController.text,
                                          username: userNameController.text,
                                          bio: bioController.text);
                                    });
                                  },
                                );
                              } else {
                                Get.showSnackbar(const GetSnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                  borderRadius: 5,
                                  title: "Username Taken",
                                  message:
                                      "The username you entered is already taken. Please choose a different one.",
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
