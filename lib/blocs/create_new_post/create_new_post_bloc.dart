import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/create_new_post/create_new_post_event.dart';
import 'package:sing_app/blocs/create_new_post/create_new_post_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/graph_url_info_model.dart';
import 'package:sing_app/data/repository/forum_repository.dart';
import 'package:sing_app/data/repository/media_repository.dart';
import 'package:sing_app/data/repository/ss_repository.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:sing_app/utils/file_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/parse_util.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../application.dart';
import '../../config/app_localization.dart';
import '../../data/event_bus/event_bus_event.dart';
import '../../data/models/file_picker_model.dart';
import '../../data/models/forum.dart';
import '../../data/models/post.dart';

class CreateNewPostBloc extends Bloc<CreateNewPostEvent, CreateNewPostState> {
  final Forum forum;
  final BaseForumRepository forumRepository;
  final BaseMediaRepository mediaRepository;
  final BaseSsRepository ssRepository;
  final bool isOpenGallery;
  final Post? postEdit;
  final CreateNewPostBottomSheetFromType fromType;

  List<String> graphBlacklistDomains = AppConfig.instance.values.graphBlacklistDomains;

  List<FilePickerModel> listFilePicked = [];
  List<String> mediasRemove = [];
  GraphUrlInfo? graphUrlInfo;
  bool isHaveUrl = false;

  CreateNewPostBloc(
      {required this.forum,
      required this.forumRepository,
      required this.mediaRepository,
      required this.ssRepository,
      this.isOpenGallery = false,
      this.postEdit,
      required this.fromType})
      : super(CreateNewPostInitialState()) {
    on<CreateNewPostInitialEvent>((event, emit) async {
      if (event.isOpenGallery) {
        emit(CreateNewPostOpenGalleryState());
      }
      if (event.initialPost != null) {
        for (var media in event.initialPost!.medias) {
          listFilePicked.add(FilePickerModel(mediaExist: media));
        }
        graphUrlInfo = event.initialPost!.link;
        emit(CreateNewPostInitialState());
      }
    });
    on<CreateNewPostGetImageFromGallerySuccessEvent>((event, emit) async {
      await _mapGetImageFromGalleryToState(event, emit);
    });
    on<GetVideoFromGallerySuccessEvent>((event, emit) async {
      await _mapGetVideoFIleFromGalleryToState(event, emit);
    });
    on<RemoveFilePickedEvent>((event, emit) async {
      await _mapRemoveFilePickedEventToState(event, emit);
    });
    on<ActionCreateNewPostEvent>((event, emit) async {
      await _mapActionCreateNewPostEventToState(event, emit);
    });
    on<ActionUpdatePostEvent>((event, emit) async {
      await _mapActionUpdatePostEventToState(event, emit);
    });
    on<CreateNewPostGetInfoUrlEvent>((event, emit) async {
      await _mapGetInfoUrlEventToState(event, emit);
    });
    on<CreateNewPostRemoveGraphInfoUrlEvent>((event, emit) async {
      graphUrlInfo = null;
      emit(CreateNewPostGetInfoUrlSuccessState());
      emit(CreateNewPostInitialState());
    });
    on<CreateNewPostSetIsHaveUrlEvent>((event, emit) async {
      isHaveUrl = event.isHaveUrl;
      emit(CreateNewPostGetInfoUrlSuccessState());
      emit(CreateNewPostInitialState());
    });
  }

  Future _mapGetImageFromGalleryToState(
      CreateNewPostGetImageFromGallerySuccessEvent event,
      Emitter<CreateNewPostState> emit) async {
    listFilePicked.removeWhere((element) => element.photoAsset != null);
    for (var element in event.assetsPickerList) {
      listFilePicked.add(FilePickerModel(videoFile: null, photoAsset: element));
    }
    emit(CreateNewPostInitialState());
    emit(NewFileState());
  }

  Future _mapRemoveFilePickedEventToState(
      RemoveFilePickedEvent event, Emitter<CreateNewPostState> emit) async {
    if (event.item.mediaExist != null) {
      mediasRemove.add(event.item.mediaExist?.mediaId ?? '');
    }
    listFilePicked.remove(event.item);
    emit(CreateNewPostInitialState());
    emit(NewFileState());
  }

  Future _mapGetVideoFIleFromGalleryToState(GetVideoFromGallerySuccessEvent event,
      Emitter<CreateNewPostState> emit) async {
    final Uint8List? videoThumb = await VideoThumbnail.thumbnailData(
        video: event.file.path, imageFormat: ImageFormat.JPEG, quality: 100);
    listFilePicked.add(FilePickerModel(
        videoFile: event.file, photoAsset: null, videoThumb: videoThumb));

    emit(CreateNewPostInitialState());
    emit(NewFileState());
  }

  Future _mapActionCreateNewPostEventToState(
      ActionCreateNewPostEvent event, Emitter<CreateNewPostState> emit) async {
    emit(CreateNewPostLoadingIndicatorState(
        isLoading: true, message: l('Posting') + '...'));
    emit(CreateNewPostInitialState());

    List<String> idMedias = [];
    List<MultipartFile> photoMultipartFiles = [];

    /// check file size in MB and file type
    FileCheck fileCheck = await _checkFile(photoMultipartFiles);
    if (fileCheck == FileCheck.allow) {
      /// upload photo and add id to array idMedias
      DefaultSsResponse resUploadMedia = await _getMediasIdFromResApiUploadMedia(
          idMedias, photoMultipartFiles);
      if (resUploadMedia.success) {
        final resCreateNewPost = await forumRepository.createNewPost(
            forumId: forum.groupId,
            message: event.message,
            medias: idMedias,
            graphUrlInfo: graphUrlInfo);
        if (resCreateNewPost.success) {
          Post post = Post.fromJson(resCreateNewPost.data);
          App.instance.eventBus.fire(
              EventBusFetchNewPostInForumDetailSuccessEvent(
                  postId: post.postId, isAddPost: true));
          emit(const CreateNewPostSuccessfullyState(isSuccess: true));
        } else {
          emit(CreateNewPostSuccessfullyState(
              isSuccess: false, errorMessage: resCreateNewPost.error?.message));
        }
      } else {
        emit(CreateNewPostSuccessfullyState(
            isSuccess: false, errorMessage: resUploadMedia.error?.message));
      }
    }

    emit(const CreateNewPostLoadingIndicatorState(isLoading: false));
    emit(CreateNewPostInitialState());
    return;
  }

  _mapActionUpdatePostEventToState(
      ActionUpdatePostEvent event, Emitter<CreateNewPostState> emit) async {
    emit(CreateNewPostLoadingIndicatorState(
        isLoading: true, message: l('Saving') + '...'));
    List<String> idMedias = [];
    List<MultipartFile> photoMultipartFiles = [];

    /// check file size in MB and file type
    FileCheck fileCheck = await _checkFile(photoMultipartFiles);
    if (fileCheck == FileCheck.allow) {
      /// upload photo and add id to array idMedias
      DefaultSsResponse resUploadMedia = await _getMediasIdFromResApiUploadMedia(
          idMedias, photoMultipartFiles);
      if (resUploadMedia.success) {
        final resUpdatePost = await forumRepository.updatePost(
            postId: postEdit?.postId ?? '',
            message: event.message,
            medias: idMedias,
            graphUrlInfo: graphUrlInfo);
        if (resUpdatePost.success) {
          if (fromType == CreateNewPostBottomSheetFromType.postDetail) {
            App.instance.eventBus
                .fire(EventBusFetchNewPostInPostDetailSuccessEvent());
          } else {
            App.instance.eventBus.fire(
                EventBusFetchNewPostInForumDetailSuccessEvent(
                    postId: postEdit?.postId ?? '', isAddPost: false));
          }

          for (var id in mediasRemove) {
            await forumRepository.deleteMedia(mediaId: id);
          }
          emit(const UpdatePostSuccessfullyState(isSuccess: true));
        } else {
          emit(UpdatePostSuccessfullyState(
              isSuccess: false, errorMessage: resUpdatePost.error?.message));
        }
      }else{
        emit(UpdatePostSuccessfullyState(
            isSuccess: false, errorMessage: resUploadMedia.error?.message));
      }
    }

    emit(const CreateNewPostLoadingIndicatorState(isLoading: false));
    emit(CreateNewPostInitialState());
    return;
  }

  Future<DefaultSsResponse> _getMediasIdFromResApiUploadMedia(
      List<String> idMedias, List<MultipartFile> photoMultipartFiles) async {
    for (var item in listFilePicked) {
      if (item.videoFile != null) {
        final DefaultSsResponse resUploadPhoto =
            await forumRepository.uploadVideo(file: item.videoFile!);
        if (resUploadPhoto.success && resUploadPhoto.data["media_id"] != null) {
          idMedias.add(resUploadPhoto.data["media_id"]);
        } else {
          LoggerUtil.printLog(
              message: 'resUploadPhoto: ${resUploadPhoto.error?.message}');
          return resUploadPhoto;
        }
      } else if (item.mediaExist != null) {
        idMedias.add(item.mediaExist?.mediaId ?? '');
      }
    }
    for (var item in photoMultipartFiles) {
      final resUploadPhoto = await forumRepository.uploadAssetPhoto(multipartFile: item);
      if (resUploadPhoto.success && resUploadPhoto.data["media_id"] != null) {
        idMedias.add(resUploadPhoto.data["media_id"]);
      } else {
        LoggerUtil.printLog(
            message: 'resUploadPhoto: ${resUploadPhoto.error?.message}');
        return resUploadPhoto;
      }
    }
    return DefaultSsResponse(success: true);
  }

  _mapGetInfoUrlEventToState(CreateNewPostGetInfoUrlEvent event,
      Emitter<CreateNewPostState> emit) async {
    emit(const CreateNewPostGetInfoUrlLoadingState(isLoading: true));
    final res = await ssRepository.getUrlInfo(url: event.url);
    if (res.success) {
      isHaveUrl = true;
      graphUrlInfo = res.data;
    }else{
      if(res.error?.code==400){
        emit(CreateNewPostPopupUrlNotAllowState(message: l('This url violates our community standards')));
      }
    }
    emit(CreateNewPostGetInfoUrlSuccessState());
    emit(const CreateNewPostGetInfoUrlLoadingState(isLoading: false));
  }

  int getMaxLengthPhotoCanSelected(int maxLengthFile) {
    final List<FilePickerModel> listVideoPicked = listFilePicked
        .where((element) =>
            element.videoFile != null || element.mediaExist != null)
        .toList();
    return maxLengthFile - listVideoPicked.length;
  }

  Future<FileCheck> _checkFile(List<MultipartFile> photoMultipartFile) async {
    FileCheck fileCheck = FileCheck.allow;
    for (var item in listFilePicked) {
      if (item.videoFile != null) {
        fileCheck = validateFile(type: FileType.video, file: item.videoFile);
      } else if (item.photoAsset != null) {
        MultipartFile multipartFile =
            await Parse.toMultipartFile(item.photoAsset!);
        fileCheck =
            validateFile(type: FileType.photo, multipartFile: multipartFile);
        photoMultipartFile.add(multipartFile);
      }
    }
    return fileCheck;
  }
}
