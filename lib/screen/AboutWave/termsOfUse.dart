import 'package:flutter/material.dart';

import '../../utils/devicesize.dart';
class termsOfUseScreen extends StatelessWidget {
  const termsOfUseScreen({Key? key}) : super(key: key);

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
        title: const Text('Terms of Use',style: TextStyle(
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
                  'Permission is allowed to temporarily download one duplicate of the materials (data or programming) on Wave site for individual and non-business use only. This is the just a permit of license and not an exchange of title, and under this permit you may not:\n\n i. Modify or copy the materials\n\n ii. Use the materials for any commercial use , or for any public presentation (business or non-business)\n\n iii. Attempt to decompile or rebuild any product or material contained on Wave app\n\n iv. remove any copyright or other restrictive documentations from the materials'),
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
            ],
          ),
        ),
      ),
    );
  }
}
