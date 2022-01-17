import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';

class changeChatBG extends StatelessWidget {

  final String uid;
  final String chatId;

  changeChatBG({required this.uid,required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: const Text('Remove wallpaper'),
                content: const Text('Are you sure you want to remove the current wallpaper ?'),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                actions: [
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text('No')),
                  TextButton(onPressed: () {
                    FirebaseFirestore.instance.collection(uid).doc(chatId).update({'chatbg':-1}).then((value) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Done ! Changes will be reflected after restart of the app')));
                    });
                  }, child: const Text('Yes',style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700
                  ),)),
                ],
              );
            },);
          }, icon: Icon(Icons.delete_forever))
        ],
        title: const Text(
          'Set wallpaper',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            mainAxisSpacing: displayHeight(context)*0.012,
            crossAxisSpacing: displayWidth(context)*0.018,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text('Are you sure you want to set this as your new chat wallpaper ?'),
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: const Text('No')),
                      TextButton(onPressed: () {
                        FirebaseFirestore.instance.collection(uid).doc(chatId).update({'chatbg':index}).then((value) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Done ! Changes will be reflected after restart of the app')));
                        });
                      }, child: const Text('Yes',style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700
                      ),)),
                    ],
                  );
                },);
              },
                child: Image.asset('images/chat_bg${index}.jpg',fit: BoxFit.cover,));
          },
        ),
      ),
    );
  }
}
