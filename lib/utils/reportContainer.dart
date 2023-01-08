import 'package:flutter/material.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/manager.dart';
import 'devicesize.dart';
class reportContainer extends StatefulWidget {
  final String? postId;
  final String? postOwnerId;
  final String? myUid;
  reportContainer({this.myUid,this.postId,this.postOwnerId});

  @override
  _reportContainerState createState() => _reportContainerState();
}

class _reportContainerState extends State<reportContainer> {
  bool loadScreen = false;
  @override
  Widget build(BuildContext cx) {
    return Container(
      height: displayHeight(cx) * 0.8,
      child: (loadScreen)?Center(child: Text('Reporting...'),):
      Padding(
        padding: const EdgeInsets.all(
            16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.start,
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Center(
                  child: Text('Report',
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight:
                        FontWeight
                            .bold,
                        fontSize:
                        displayWidth(
                            cx) *
                            0.05,
                      ))),
              Divider(
                height: displayHeight(context)*0.03,
                color: Colors.black54,
              ),
              Text(
                'Why are you reporting this post?',
                style: TextStyle(
                    color:
                    Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                    displayWidth(
                        cx) *
                        0.04),
              ),
              Opacity(
                child: Divider(height: displayHeight(context)*0.012,),
                opacity: 0.0,
              ),
              Text(
                'After you report this post ,we will investigate and if found liable of the assertion, actions shall be taken duly. The post will be concealed momentarily.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize:
                  displayWidth(
                      context) *
                      0.036,
                ),
              ),
              const Opacity(
                  opacity: 0.0,
                  child: Divider()),
              ListTile(
                leading: Image.asset(
                  'images/adult.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                visualDensity:
                const VisualDensity(
                    vertical: -4,
                    horizontal: 0),
                title: const Text(
                    "Nudity or Sexual Content"),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await Provider.of<manager>(cx,listen: false).reportPost(widget.myUid!, "Nudity or Sexual Content",
                      widget.postOwnerId!, widget.postId!);
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/dontlike.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                visualDensity:
                const VisualDensity(
                    vertical: -4,
                    horizontal: 0),
                title: const Text(
                  "I don't like it",
                  style: TextStyle(),
                ),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await Provider.of<manager>(cx,listen: false).reportPost(widget.myUid!, "I don't like it",
                      widget.postOwnerId!, widget.postId!);
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/scam.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                title: const Text(
                    "Scam or fraud"),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await Provider.of<manager>(cx,listen: false).reportPost(widget.myUid!, "Scam or fraud",
                      widget.postOwnerId!, widget.postId!);
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/violence.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                visualDensity:
                const VisualDensity(
                    vertical: -4,
                    horizontal: 0),
                title: const Text(
                    "Violence"),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await Provider.of<manager>(cx,listen: false).reportPost(widget.myUid!, "Violence",
                      widget.postOwnerId!, widget.postId!);
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/hurt.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                visualDensity:
                const VisualDensity(
                    vertical: -4,
                    horizontal: 0),
                title: const Text(
                    "Suicide or self injury case"),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await Provider.of<manager>(cx,listen: false).reportPost(widget.myUid!, "Suicide or self injury case",
                      widget.postOwnerId!, widget.postId!);
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class reportContainerForComment extends StatefulWidget {
  final String? postId;
  final String? commentId;
  final String? myUid;
  reportContainerForComment({this.myUid,this.postId,this.commentId});

  @override
  _reportContainerForCommentState createState() => _reportContainerForCommentState();
}

class _reportContainerForCommentState extends State<reportContainerForComment> {
  bool loadScreen = false;
  @override
  Widget build(BuildContext cx) {
    return Container(
      height: displayHeight(cx) * 0.8,
      child: (loadScreen)?const Center(child: Text('Reporting...'),):
      Padding(
        padding: const EdgeInsets.all(
            16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.start,
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Center(
                  child: Text('Report',
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontWeight:
                        FontWeight
                            .bold,
                        fontSize:
                        displayWidth(
                            cx) *
                            0.05,
                      ))),
              Divider(
                height: displayHeight(context)*0.03,
                color: Colors.black54,
              ),
              Text(
                'Why are you reporting this comment?',
                style: TextStyle(
                    color:
                    Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                    displayWidth(
                        cx) *
                        0.04),
              ),
              Opacity(
                child: Divider(height: displayHeight(context)*0.012,),
                opacity: 0.0,
              ),
              Text(
                'After you report this comment ,we will investigate and if found liable of the assertion, actions shall be taken duly.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize:
                  displayWidth(
                      context) *
                      0.036,
                ),
              ),
              const Opacity(
                  opacity: 0.0,
                  child: Divider()),
              ListTile(
                leading: Image.asset(
                  'images/adult.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                visualDensity:
                const VisualDensity(
                    vertical: -4,
                    horizontal: 0),
                title: const Text(
                    "Nudity or Sexual Content"),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await reportThisComment(widget.postId!,widget.commentId!,"Nudity or Sexual Content");
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/dontlike.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                visualDensity:
                const VisualDensity(
                    vertical: -4,
                    horizontal: 0),
                title: const Text(
                  "I don't like it",
                  style: TextStyle(),
                ),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await reportThisComment(widget.postId!,widget.commentId!,"I don't like it");
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/scam.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                title: const Text(
                    "Scam or fraud"),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await reportThisComment(widget.postId!,widget.commentId!,"Scam or fraud");
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/violence.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                visualDensity:
                const VisualDensity(
                    vertical: -4,
                    horizontal: 0),
                title: const Text(
                    "Violence"),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await reportThisComment(widget.postId!,widget.commentId!,"Scam or fraud");
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'images/hurt.png',
                  height: displayHeight(
                      context) *
                      0.03,
                  width: displayWidth(
                      context) *
                      0.05,
                  fit: BoxFit.contain,
                ),
                visualDensity:
                const VisualDensity(
                    vertical: -4,
                    horizontal: 0),
                title: const Text(
                    "Suicide or self injury case"),
                onTap: () async {
                  setState(() {
                    loadScreen = true;
                  });
                  await reportThisComment(widget.postId!,widget.commentId!,"Suicide or self injury case");
                  setState(() {
                    loadScreen = false;
                  });
                  Navigator.pop(cx);
                  ScaffoldMessenger.of(cx).showSnackBar(SnackBar(content: Text('Done !!')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}