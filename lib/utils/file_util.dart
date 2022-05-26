import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/manager/app_lock_manager.dart';

import '../config/app_config.dart';
import '../config/app_localization.dart';
import 'alert_util.dart';

int maxSizeVideoKb =
    AppConfig.instance.values.medias?.post?.video?.maxSize ?? 50 * 1024 * 1024;
int maxSizePhotoKb =
    AppConfig.instance.values.medias?.post?.image?.maxSize ?? 50 * 1024 * 1024;
List<String>? photosAllow =
    AppConfig.instance.values.medias?.post?.image?.allow;
List<String>? videosAllow =
    AppConfig.instance.values.medias?.post?.video?.allow;

Future<File?> onGetPhotoFromGallery(
    {required BuildContext context,
    required ImagePicker picker,
    required Function funcPermission}) async {
  if (await Permission.photos.request().isGranted) {
    try {
      AppLockManager.instance.isOpenGallery = true;
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        return imageFile;
      } else {
        showSnackBar(context, message: 'You have not selected a photo');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  } else {
    funcPermission();
  }
  return null;
}

Future<List<File>?> onGetMultiPhoto(
    {required BuildContext context,
    required ImagePicker picker,
    required Function funcPermission}) async {
  if (await Permission.photos.request().isGranted) {
    try {
      AppLockManager.instance.isOpenGallery = true;
      final pickedFiles = await picker.pickMultiImage(
        imageQuality: 100,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        final List<File> listFile = [];
        for (var item in pickedFiles) {
          File imageFile = File(item.path);
          listFile.add(imageFile);
        }
        return listFile;
      } else {
        // showSnackBarError(context: context, message: 'File error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  } else {
    funcPermission();
  }
  return null;
}

Future<List<Asset>?> onGetMultiImagePicker(
    {required BuildContext context,
    required List<Asset> selectedAssets,
    int maxImages = 8}) async {
  if (await Permission.storage.request().isGranted) {
    try {
      AppLockManager.instance.isOpenGallery = true;
      List<Asset> resultList = await MultiImagePicker.pickImages(
        selectedAssets: selectedAssets,
        maxImages: maxImages,
        enableCamera: true,
        materialOptions:
             MaterialOptions(selectionLimitReachedText: '${l('You can only select up to')} $maxImages files'),
      );
      return resultList;
    } catch (e) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  } else {
    _showPhotoPermissionAlertDialog(context);
  }
  return null;
}

Future<File?> onGetVideo(
    {required BuildContext context, required ImagePicker picker}) async {
  if (await Permission.photos.request().isGranted) {
    try {
      AppLockManager.instance.isOpenGallery = true;
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        // showSnackBarError(context: context, message: 'File error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  } else {
    _showPhotoPermissionAlertDialog(context);
  }
  return null;
}

_showPhotoPermissionAlertDialog(BuildContext context) {
  // set up the buttons
  final cancelButton = TextButton(
    child: Text(l("Cancel")),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  final settingsButton = TextButton(
    child: Text(l("Settings")),
    onPressed: () {
      Navigator.pop(context);
      openAppSettings();
    },
  );

  // set up the AlertDialog
  final alert = AlertDialog(
    title: Text(l('This feature requires photos access')),
    content: Text(l('To enable access, tap Settings and turn on Photo')),
    actions: [
      cancelButton,
      settingsButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

FileCheck validateFile(
    {File? file,
    MultipartFile? multipartFile,
    required FileType type,
    isToastNotAllow = true}) {
  FileCheck fileCheck = FileCheck.allow;
  if (multipartFile != null) {
    //check in kb
    if (multipartFile.length > maxSizePhotoKb) {
      fileCheck = FileCheck.notAllowSizePhoto;
    }
    if (photosAllow
            ?.contains(multipartFile.filename?.split('.').last.toLowerCase()) ==
        false) {
      fileCheck = FileCheck.notAllowFilePhoto;
    }
  } else if (file != null) {
    //check in kb
    switch (type) {
      case FileType.photo:
        if (file.lengthSync() > maxSizePhotoKb) {
          fileCheck = FileCheck.notAllowSizePhoto;
        }
        break;
      case FileType.video:
        if (file.lengthSync() > maxSizeVideoKb) {
          fileCheck = FileCheck.notAllowSizeVideo;
        }
        break;
    }

    String fileLastName = file.path.split('.').last.toLowerCase();
    switch (type) {
      case FileType.photo:
        if (photosAllow?.contains(fileLastName) == false) {
          fileCheck = FileCheck.notAllowFilePhoto;
        }
        break;
      case FileType.video:
        if (videosAllow?.contains(fileLastName) == false) {
          fileCheck = FileCheck.notAllowFileVideo;
        }
        break;
    }
  }
  if (isToastNotAllow) {
    alertFileNotAllow(fileCheck);
  }
  return fileCheck;
}

alertFileNotAllow(FileCheck fileCheck) {
  switch (fileCheck) {
    case FileCheck.notAllowSizePhoto:
      Fluttertoast.showToast(
          msg:
              '${l("Photo size is less than or equal to")} ${maxSizePhotoKb / (1024 * 1024)} MB');
      break;
    case FileCheck.notAllowSizeVideo:
      Fluttertoast.showToast(
          msg: '${l('Video size is less than or equal to')} ${maxSizeVideoKb / (1024 * 1024)} MB');
      break;
    case FileCheck.notAllowFilePhoto:
      Fluttertoast.showToast(
          msg: photosAllow != null
              ? '${l("Photo format only")} ${photosAllow.toString()}'
              : l('Wrong file format'));
      break;
    case FileCheck.notAllowFileVideo:
      Fluttertoast.showToast(
          msg: videosAllow != null
              ? '${l("Video format only")} ${videosAllow.toString()} '
              : l('Wrong file format'));
      break;
    case FileCheck.allow:
      break;
  }
}
