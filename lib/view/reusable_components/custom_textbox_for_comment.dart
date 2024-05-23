import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import 'package:wave/utils/constants/custom_icons.dart';
import 'package:wave/utils/device_size.dart';

import '../../utils/constants/custom_fonts.dart';

// ignore: must_be_immutable
class CustomTextBoxForComments extends StatelessWidget {
  Widget? child;
  dynamic formKey;
  dynamic sendButtonMethod;
  dynamic commentController;
  ImageProvider? userImage;
  String? labelText;
  String? errorText;
  Widget? sendWidget;
  Color? backgroundColor;
  Color? textColor;
  bool withBorder;
  Widget? header;
  FocusNode? focusNode;
  CustomTextBoxForComments(
      {this.child,
      this.header,
      this.sendButtonMethod,
      this.formKey,
      this.commentController,
      this.sendWidget,
      this.userImage,
      this.labelText,
      this.focusNode,
      this.errorText,
      this.withBorder = true,
      this.backgroundColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: child!),
        Divider(
          height: 1,
        ),
        header ?? SizedBox.shrink(),
        ListTile(
          tileColor: backgroundColor,
          leading: CircleAvatar(radius: 20, backgroundImage: userImage),
          title: Form(
            key: formKey,
            child: SizedBox(
              child: TextFormField(
                controller: commentController,
                maxLines: 5,
                minLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: CustomFont.poppins,
                    fontSize: 12),
                decoration: InputDecoration(
                  labelText: "Comment",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: CustomFont.poppins,
                      fontSize: 14),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomColor.authTextBoxBorderColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomColor.authTextBoxBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomColor.authTextBoxBorderColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: sendButtonMethod,
            child: sendWidget,
          ),
        ),
      ],
    );
  }

  /// This method is used to parse the image from the URL or the path.
  /// `CommentBox.commentImageParser(imageURLorPath: 'url_or_path_to_image')`
  static ImageProvider commentImageParser({imageURLorPath}) {
    try {
      //check if imageURLorPath
      if (imageURLorPath is String) {
        if (imageURLorPath.startsWith('http')) {
          return CachedNetworkImageProvider(
            imageURLorPath);
        } else {
          return AssetImage(imageURLorPath);
        }
      } else {
        return imageURLorPath;
      }
    } catch (e) {
      //throw error
      throw Exception('Error parsing image: $e');
    }
  }
}
