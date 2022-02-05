import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus/models/StoryModel.dart';
import 'package:nexus/models/userModel.dart';
import 'package:nexus/providers/manager.dart';
import 'package:nexus/screen/Story/storyViewersScreen.dart';
import 'package:nexus/utils/devicesize.dart';
import 'package:nexus/utils/widgets.dart';
import 'package:provider/provider.dart';

class viewStory extends StatefulWidget {
  final StoryModel? story;
  final String? myUid;
  viewStory({this.myUid, this.story});

  @override
  State<viewStory> createState() => _viewStoryState();
}

class _viewStoryState extends State<viewStory> {

  bool? init;
  @override
  void initState() {
    init=true;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if(init!){
      Provider.of<manager>(context).increaseViewsOnStory(widget.story!.uid!, widget.myUid!);
    }
    init = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, NexusUser> allUsers =
        Provider.of<manager>(context).fetchAllUsers;
    return SafeArea(
        child: Scaffold(
            body: Container(
      color: Colors.grey,
      height: displayHeight(context),
      width: displayWidth(context),
      child: Stack(
        alignment: Alignment.center,
        // fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: widget.story!.story!,
            fit: BoxFit.contain,
            height: displayHeight(context) * 0.7,
            width: displayWidth(context),
          ),
          Positioned(
              top: displayHeight(context) * 0.03,
              left: displayWidth(context) * 0.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (allUsers[widget.story!.uid]!.dp.isEmpty)
                      ? CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          radius: displayWidth(context) * 0.06,
                        )
                      : CircleAvatar(
                          radius: displayWidth(context) * 0.065,
                          backgroundImage: CachedNetworkImageProvider(
                              allUsers[widget.story!.uid]!.dp),
                        ),
                  const Opacity(
                      opacity: 0.0,
                      child: VerticalDivider(
                        width: 5,
                      )),
                  Text(
                    allUsers[widget.story!.uid]!.username,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )),
          Positioned(
              top: displayHeight(context) * 0.025,
              right: displayWidth(context) * 0.02,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
          Positioned(
            bottom: displayHeight(context) * 0.01,
            right: displayWidth(context) * 0.02,
            child: (widget.story!.uid == widget.myUid)
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            //content: Text('Are you sure you want to sign-out ?'),
                            title: const Text('Remove Story'),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: TextButton(
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: TextButton(
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  onPressed: () {
                                    Provider.of<manager>(context, listen: false)
                                        .deleteStoryFromServer(widget.myUid!);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Successfully removed your story')));
                                  },
                                )),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                : const SizedBox(),
          ),
          Positioned(
            bottom: displayHeight(context) * 0.01,
            left: displayWidth(context) * 0.04,
            child: (widget.story!.uid == widget.myUid)
                ? IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        context: context,
                        builder: (context) {
                          return Container(
                            height: displayHeight(context) * 0.4,
                            width: displayWidth(context),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.all(16.0),
                              itemBuilder: (context, index) {
                                return displayProfileHeads(
                                    context,
                                    allUsers[
                                        allUsers[widget.myUid]!.views[index]]!);
                              },
                              itemCount: allUsers[widget.myUid]!.views.length,
                            ),
                          );
                        },
                      );
                    },
                    color: Colors.white,
                    icon: Icon(Icons.visibility))
                : const SizedBox(),
          ),
        ],
      ),
    )));
  }
}
