import 'package:flutter/material.dart';
import 'package:nexus/utils/widgets.dart';
class OpenSourceDetail extends StatelessWidget {
  const OpenSourceDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Open Source Development',style: TextStyle(
          color: Colors.black87,
        ),),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wave is an open source project. Developers around the globe can contribute to it. You can examine more information on our :'),
            Opacity(child: Divider(),opacity: 0.0,),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Source Code at : ',style: TextStyle(
                    color: Colors.black87,fontWeight: FontWeight.bold
                  ),),
                  InkWell(
                    onTap: ()async {
                      await openLink('https://github.com/Alpha17-2/Wave');
                    },
                      child: Text('https://github.com/Alpha17-2/Wave',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
