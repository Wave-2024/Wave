import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wave/utils/constants/custom_colors.dart';

Future<XFile?> pickImage(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  final androidInfo = await DeviceInfoPlugin().androidInfo;

  // Check if we are running on Android

  int sdkInt = androidInfo.version.sdkInt;

  // Check API level for handling permissions
  if (sdkInt >= 29) {
    "sdk version greater than 29".printInfo();
    // Android 10 and above, handle scoped storage
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      // Permission not granted, handle accordingly
      return null;
    }
  } else {
    // For Android versions below 10, check for storage permission
    "sdk version less than 29".printInfo();

    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Permission not granted, handle accordingly
      return null;
    }
  }

  // If permissions are granted, proceed to pick an image
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
  return pickedFile;
}

Future<List<XFile>?> pickMultipleMediaFiles(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  final androidInfo = await DeviceInfoPlugin().androidInfo;

  // Check if we are running on Android

  int sdkInt = androidInfo.version.sdkInt;

  // Check API level for handling permissions
  if (sdkInt >= 29) {
    "sdk version greater than 29".printInfo();
    // Android 10 and above, handle scoped storage
    var status = await Permission.photos.request();
    if (!status.isGranted) {
      // Permission not granted, handle accordingly
      return null;
    }
  } else {
    // For Android versions below 10, check for storage permission
    "sdk version less than 29".printInfo();

    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // Permission not granted, handle accordingly
      return null;
    }
  }

  // If permissions are granted, proceed to pick an image
  final List<XFile> pickedFile = await picker.pickMultipleMedia(limit: 5,);
  return pickedFile;
}

Future<CroppedFile?> cropImage(File pickedFile,
    {List<CropAspectRatioPreset>? list, CropStyle? cropStyle}) async {
  CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      cropStyle: cropStyle ?? CropStyle.rectangle,
      aspectRatioPresets: Platform.isAndroid
          ? list ??
              [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Adjust Photo',
            toolbarColor: CustomColor.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ]);

  return croppedFile;
}
