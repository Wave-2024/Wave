import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/models/user_model.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({
    super.key,
  });

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String? chatId;
  User? otherUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otherUser = Get.arguments['otherUser'];
    chatId = Get.arguments['chatId'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
