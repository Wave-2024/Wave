import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wave/utils/constants/custom_colors.dart';
import '../../utils/constants/custom_fonts.dart';

// ignore: must_be_immutable
class CustomTextBoxForComments extends StatelessWidget {
  Widget? child;
  dynamic formKey;
  dynamic sendButtonMethod;
  dynamic commentController;
  String? imageUrl;
  String? fontFamily;
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
      this.imageUrl,
      this.labelText,
      this.fontFamily,
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
        const Divider(
          height: 1,
        ),
        header ?? const SizedBox.shrink(),
        ListTile(
          visualDensity: VisualDensity(horizontal: -2),
          tileColor: backgroundColor,
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(imageUrl!)
                : null,
            child: imageUrl == null || imageUrl!.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          title: Form(
            key: formKey,
            child: SizedBox(
              child: TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: commentController,
                maxLines: 5,
                minLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: fontFamily ?? CustomFont.poppins,
                    fontSize: fontFamily != null ? 14 : 12),
                decoration: InputDecoration(
                  labelText: labelText ?? "Comment",
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CustomColor.authTextBoxBorderColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          trailing: InkWell(
            onTap: sendButtonMethod,
            child: sendWidget,
          ),
        ),
      ],
    );
  }
}
