import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/controllers/PostController/create_post_controller.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/enums.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/screens/CreatePostScreen/add_image_for_post_box.dart';

class CreatePostScreen extends StatelessWidget {
  CreatePostScreen({super.key});

  TextEditingController captionController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  List<User> mentionedUsers = [];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Post",
            style: TextStyle(
              fontFamily: CustomFont.poppins,
              fontSize: 16.5,
              letterSpacing: -0.1,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: CustomColor.primaryBackGround,
        ),
        backgroundColor: CustomColor.primaryBackGround,
        body: SafeArea(
          child: Consumer2<CreatePostController, UserDataController>(
            builder: (context, postController, userDataController, child) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder for selected media files
                      AddImageForPostBox(postController: postController),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Caption",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: CustomFont.poppins,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: CustomColor.authTextBoxBorderColor),
                          color: CustomColor.primaryBackGround,
                        ),
                        child: TextFormField(
                          maxLines: 6,
                          minLines: 3,
                          controller: captionController,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: CustomFont.poppins,
                                  color: Colors.black,
                                  fontSize: 14),
                              border: InputBorder.none,
                              hintText: "Tell us about your new post !!"),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        "Mention People",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: CustomFont.poppins,
                            fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () =>
                            Get.toNamed(AppRoutes.searchToMentionScreen),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            width: double.infinity,
                            height: displayHeight(context) * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: CustomColor.authTextBoxBorderColor),
                              color: CustomColor.primaryBackGround,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.search),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Search People",
                                      style: TextStyle(
                                          fontFamily: CustomFont.poppins,
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                const Icon(Icons.arrow_right)
                              ],
                            )),
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: postController.mentionedUsers.isNotEmpty,
                        child: Container(
                          // color: Colors.yellow.shade100,
                          height: displayHeight(context) * 0.12,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: postController.mentionedUsers.length,
                            itemBuilder: (BuildContext context, int index) {
                              User user = postController.mentionedUsers[index];
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        (user.displayPicture != null &&
                                                user.displayPicture!.isNotEmpty)
                                            ? NetworkImage(user.displayPicture!)
                                            : null,
                                    radius: 28,
                                    child: user.displayPicture == null ||
                                            user.displayPicture!.isEmpty
                                        ? const Icon(Icons.person)
                                        : null,
                                  ),
                                  // ignore: prefer_const_constructors
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        user.username,
                                        style: TextStyle(
                                            fontFamily: CustomFont.poppins,
                                            fontSize: 11,
                                            letterSpacing: 0.1),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Visibility(
                                          visible: user.verified,
                                          child: Image.asset(
                                            CustomIcon.verifiedIcon,
                                            height: 12,
                                          ))
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: SizedBox(
                          width: displayWidth(context) * 0.8,
                          child: MaterialButton(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            height: displayHeight(context) * 0.06,
                            onPressed: () async {
                              final res = await postController.createNewPost(
                                  userId:
                                      fb.FirebaseAuth.instance.currentUser!.uid,
                                  caption: captionController.text);
                              if (res.responseStatus) {
                                postController.resetController();
                                 Get.showSnackbar(const GetSnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                  borderRadius: 5,
                                  title: "Post Successfull!",
                                  message:
                                      "Post will be visible in a few minutes",
                                ));
                                StreamSubscription<CustomResponse>? sub;
                                sub = userDataController
                                    .updateProfile(
                                        newPostId: res.response.toString())
                                    .listen(
                                  (customRes) {
                                    if (customRes.responseStatus) {
                                      "Modified post list".printInfo();
                                    }
                                  },
                                  onDone: () {
                                    sub!.cancel();
                                  },
                                );

                               
                              } else {
                                Get.showSnackbar(GetSnackBar(
                                  backgroundColor: CustomColor.errorColor,
                                  borderRadius: 5,
                                  duration: const Duration(seconds: 2),
                                  message: res.response.message.toString(),
                                ));
                              }
                            },
                            color: CustomColor.primaryColor,
                            child: (postController.create_post ==
                                    CREATE_POST.CREATING)
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        CustomIcon.addPostIcon,
                                        height: 15,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Create Post",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: CustomFont.poppins,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
