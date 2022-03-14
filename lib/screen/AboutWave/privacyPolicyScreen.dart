import 'package:flutter/material.dart';

import '../../utils/devicesize.dart';
class privacyPolicyScreen extends StatelessWidget {
  const privacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var headingTextStyle = TextStyle(
      fontSize: displayWidth(context) * 0.045,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    var normalTextStyle = TextStyle(
      fontSize: displayWidth(context) * 0.038,
      color: Colors.black87,
    );
    var divider = const Opacity(
      opacity: 0.0,
      child: Divider(),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Privacy Policy',style: TextStyle(
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
              Text(
                'Your privacy is critical to us. Likewise, we have built up this Policy with the end goal you should see how we gather, utilize, impart and reveal and make utilization of individual data. The following blueprints our privacy policy.\n',
                style: normalTextStyle,
              ),
              Text(
                'i. Before or at the time of collecting personal information, we will identify the purposes for which information is being collected.\n\nii. We will gather and utilize individual data singularly with the target of satisfying those reasons indicated by us and for other good purposes, unless we get the assent of the individual concerned or as required by law.\n\niii. We will gather individual data by legal and reasonable means and, where fitting, with the information or assent of the individual concerned.\n\niv. We will protect individual data by security shields against misfortune or burglary, and also unapproved access, divulgence, duplicating, use or alteration.\n\nv. We will promptly provide customers with access to our policies and procedures for the administration of individual data.',
                style: normalTextStyle,
              ),
              divider,
              Text(
                'We are focused on leading our business as per these standards with a specific end goal to guarantee that the privacy of individual data is secure and maintained.',
                style: normalTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
