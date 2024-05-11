import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wave/controllers/PostController/create_post_controller.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';
import 'package:wave/view/reusable_components/mention_user_tile.dart';
import 'package:wave/view/reusable_components/user_container.dart';

class SearchToMention extends StatefulWidget {
  const SearchToMention({super.key});

  @override
  State<SearchToMention> createState() => _SearchToMentionState();
}

class _SearchToMentionState extends State<SearchToMention> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    searchController.addListener(searchUser);
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();

    super.dispose();
  }

  void searchUser() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      printInfo(info: "Searching for: ${searchController.text}");
      Provider.of<CreatePostController>(context, listen: false)
          .searchUserUsingQuery(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: SizedBox(
          height: displayHeight(context) * 0.065,
          child: TextFormField(
            onChanged: (value) => searchUser,
            controller: searchController,
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
                borderSide:
                    BorderSide(color: CustomColor.authTextBoxBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: CustomColor.authTextBoxBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: CustomColor.authTextBoxBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
          child: Consumer<CreatePostController>(
            builder: (context, postController, child) {
              if (searchController.text.isNotEmpty) {
                if (postController.searchedUsers.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount: postController.searchedUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MentionUserTile(
                          onPressed: () {
                            postController.toogleMentioningUser(
                                postController.searchedUsers[index]);
                          },
                          isMentioned: postController.mentionedUsers
                              .contains(postController.searchedUsers[index]),
                          user: postController.searchedUsers[index]);
                    },
                  );
                } else {
                  return Center(
                    child: Column(
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
                    ),
                  );
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
