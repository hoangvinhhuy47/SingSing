import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:sing_app/data/models/file_picker_model.dart';

import '../../data/models/post.dart';

@immutable
abstract class CreateNewPostEvent {
  const CreateNewPostEvent();
}

class CreateNewPostGetImageFromGallerySuccessEvent extends CreateNewPostEvent {
  final List<Asset> assetsPickerList;

  const CreateNewPostGetImageFromGallerySuccessEvent(
      {required this.assetsPickerList});
}

class GetVideoFromGallerySuccessEvent extends CreateNewPostEvent {
  final File file;

  const GetVideoFromGallerySuccessEvent({required this.file});
}

class RemoveFilePickedEvent extends CreateNewPostEvent {
  final FilePickerModel item;

  const RemoveFilePickedEvent({required this.item});
}

class ActionCreateNewPostEvent extends CreateNewPostEvent {
  final String message;

  const ActionCreateNewPostEvent({required this.message});
}

class ActionUpdatePostEvent extends CreateNewPostEvent {
  final String message;

  const ActionUpdatePostEvent({required this.message});
}

class CreateNewPostInitialEvent extends CreateNewPostEvent {
  final bool isOpenGallery;
  final Post? initialPost;

  const CreateNewPostInitialEvent(
      {required this.isOpenGallery, this.initialPost});
}

class CreateNewPostGetInfoUrlEvent extends CreateNewPostEvent {
  final String url;

  const CreateNewPostGetInfoUrlEvent({required this.url});
}

class CreateNewPostRemoveGraphInfoUrlEvent extends CreateNewPostEvent {}

class CreateNewPostSetIsHaveUrlEvent extends CreateNewPostEvent {
  final bool isHaveUrl;

  const CreateNewPostSetIsHaveUrlEvent({required this.isHaveUrl});
}
