import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_fonts.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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
      // TODO : Perform the search based on query
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                height: displayHeight(context) * 0.065,
                child: TextFormField(
                  onChanged: (value) => searchUser,
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
          ],
        ),
      ),
    );
  }
}
