import 'package:flutter/material.dart';
import 'package:nexus/utils/devicesize.dart';

class policyScreen extends StatelessWidget {
  const policyScreen({Key? key}) : super(key: key);

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
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('User policy',
            style: TextStyle(
              color: Colors.black87,
            )),

      ),
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Terms',
                  style: headingTextStyle,
                ),
                divider,
                Text(
                  'By accessing this app, you are agreeing to be bound by these app’s Terms and Conditions of Use, applicable laws and regulations and their compliance. If you disagree with any of the stated terms and conditions, you are prohibited from using or accessing this app. The materials contained in this site are secured by relevant copyright and trade mark law.',
                  style: normalTextStyle,
                ),
                divider,
                Text(
                  '2. Use License',
                  style: headingTextStyle,
                ),
                divider,
                Text(
                    'Permission is allowed to temporarily download one duplicate of the materials (data or programming) on Wave site for individual and non-business use only. This is the just a permit of license and not an exchange of title, and under this permit you may not:\n\n i. Modify or copy the materials\n ii. Use the materials for any commercial use , or for any public presentation (business or non-business)\n iii. Attempt to decompile or rebuild any product or material contained on Wave app\n iv. remove any copyright or other restrictive documentations from the materials'),
                divider,
                Text(
                  '3. Disclaimer',
                  style: headingTextStyle,
                ),
                divider,
                Text(
                  'The materials on Wave are given "as is". Wave makes no guarantees, communicated or suggested, and thus renounces and nullifies every single other warranties, including without impediment, inferred guarantees or states of merchantability, fitness for a specific reason, or non-encroachment of licensed property or other infringement of rights. Further, Wave does not warrant or make any representations concerning the precision, likely results, or unwavering quality of the utilization of the materials on its Internet site or generally identifying with such materials or on any destinations connected to this website.',
                  style: normalTextStyle,
                ),
                divider,
                Text(
                  '4. Constraints',
                  style: headingTextStyle,
                ),
                divider,
                Text(
                  'In no occasion should Wave or its suppliers subject for any harms (counting, without constraint, harms for loss of information or benefit, or because of business interference,) emerging out of the utilization or powerlessness to utilize the materials on Wave Internet app, regardless of the possibility that Wave or a Wave approved agent has been told orally or in written of the likelihood of such harm. Since a few purviews don\'t permit constraints on inferred guarantees, or impediments of obligation for weighty or coincidental harms, these confinements may not make a difference to you.',
                  style: normalTextStyle,
                ),
                divider,
                Text(
                  '5. Amendments and Errata',
                  style: headingTextStyle,
                ),
                divider,
                Text(
                  'The materials showing up on Wave app could incorporate typographical, or photographic mistakes. Wave does not warrant that any of the materials on its site are exact, finished, or current. Wave may roll out improvements to the materials contained on its site whenever without notification. Wave does not, then again, make any dedication to update the materials.',
                  style: normalTextStyle,
                ),
                divider,
                Text(
                  '6. Governing Law',
                  style: headingTextStyle,
                ),
                divider,
                Text(
                  'Any case identifying with Wave app should be administered by the laws of the country of India Wave State without respect to its contention of law provisions.',
                  style: normalTextStyle,
                ),
                divider,
                Text(
                  'Privacy Policy',
                  style: headingTextStyle,
                ),
                divider,
                Text(
                  'Your privacy is critical to us. Likewise, we have built up this Policy with the end goal you should see how we gather, utilize, impart and reveal and make utilization of individual data. The following blueprints our privacy policy.\n',
                  style: normalTextStyle,
                ),
                Text(
                  'i. Before or at the time of collecting personal information, we will identify the purposes for which information is being collected.\nii. We will gather and utilize individual data singularly with the target of satisfying those reasons indicated by us and for other good purposes, unless we get the assent of the individual concerned or as required by law.\niii. We will gather individual data by legal and reasonable means and, where fitting, with the information or assent of the individual concerned.\niv. We will protect individual data by security shields against misfortune or burglary, and also unapproved access, divulgence, duplicating, use or alteration.\nv. We will promptly provide customers with access to our policies and procedures for the administration of individual data.',
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
      ),
    );
  }
}
