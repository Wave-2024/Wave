import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/Authentication/user_controller.dart';
import 'package:wave/data/chat_data.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/utils/routing.dart';
import 'package:wave/view/reusable_components/user_container.dart';

class SearchToChat extends StatefulWidget {
  const SearchToChat({super.key});

  @override
  State<SearchToChat> createState() => _SearchToChatState();
}

class _SearchToChatState extends State<SearchToChat> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(searchUser);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void searchUser() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      Provider.of<UserDataController>(context, listen: false)
          .searchUsersByNameAndUserName(_searchController.text);
      printInfo(info: "Searching for: ${_searchController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2.0, top: 12, right: 6),
              child: SizedBox(
                height: displayHeight(context) * 0.065,
                width: displayWidth(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(AntDesign.arrow_left_outline),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) => searchUser(),
                        controller: _searchController,
                        maxLines: 1,
                        minLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: CustomFont.poppins,
                            fontSize: 14),
                        decoration: InputDecoration(
                          labelText: "Search",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Image.asset(
                              CustomIcon.searchIcon,
                              height: 2,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: CustomFont.poppins,
                              fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColor.authTextBoxBorderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColor.authTextBoxBorderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColor.authTextBoxBorderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Consumer<UserDataController>(
                builder: (context, userDataController, child) {
                  if (_searchController.text.isNotEmpty) {
                    if (userDataController.searchedUsers.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        itemCount: userDataController.searchedUsers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return UserContainerTile(
                              onTap: () async {
                                // Check if there is already a chat that exists on the database
                                /// This code snippet is checking if a chat already exists between the
                                /// current user and the searched user. Here's a breakdown of what it
                                /// does:
                                CustomResponse chatExists =
                                    await ChatData.checkIfChatExists(
                                        userDataController.user!.id,
                                        userDataController
                                            .searchedUsers[index].id);
                                if (chatExists.responseStatus) {
                                  Get.offNamed(AppRoutes.inboxScreen,
                                      arguments: {
                                        'chatId':
                                            chatExists.response.toString(),
                                        'otherUser': userDataController
                                            .searchedUsers[index]
                                      });
                                } else {
                                  CustomResponse customResponse =
                                      await ChatData.createChat(
                                          userDataController.user!.id,
                                          userDataController
                                              .searchedUsers[index].id);
                                  if (customResponse.responseStatus) {
                                    Get.offNamed(AppRoutes.inboxScreen,
                                        arguments: {
                                          'chatId': customResponse.response
                                              .toString(),
                                          'otherUser': userDataController
                                              .searchedUsers[index]
                                        });
                                  }
                                }
                              },
                              user: userDataController.searchedUsers[index]);
                        },
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            CustomIcon.noUserFoundIcon,
                            height: displayHeight(context) * 0.25,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "No User Found",
                            style: TextStyle(fontFamily: CustomFont.poppins),
                          )
                        ],
                      );
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
