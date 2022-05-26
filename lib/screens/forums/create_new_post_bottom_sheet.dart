import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:sing_app/application.dart';
import 'package:sing_app/blocs/create_new_post/create_new_post_bloc.dart';
import 'package:sing_app/blocs/create_new_post/create_new_post_event.dart';
import 'package:sing_app/blocs/create_new_post/create_new_post_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/file_picker_model.dart';
import 'package:sing_app/data/models/post.dart';
import 'package:sing_app/data/models/user_profile.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/extensions/string_extension.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:sing_app/widgets/dialog/custom_alert_dialog.dart';
import 'package:sing_app/widgets/dialog/loading_dialog.dart';
import 'package:sing_app/widgets/s2e_appbar.dart';
import 'package:sing_app/widgets/text_field_debounce.dart';
import 'package:sing_app/widgets/url_preview_widget.dart';
import '../../data/models/forum.dart';
import '../../data/repository/forum_repository.dart';
import '../../data/repository/media_repository.dart';
import '../../data/repository/ss_repository.dart';
import '../../utils/file_util.dart';
import '../../utils/styles.dart';
import '../../widgets/button_play_video.dart';
import '../../widgets/indicator_loadmore.dart';
import '../../widgets/ink_click_item.dart';

const maxLengthFile = 8;

class CreateNewPostBottomSheet extends StatelessWidget {
  final Forum forum;
  final Post? postEdit;
  final bool isOpenGalleryImmediately;
  final CreateNewPostBottomSheetFromType fromType;

  const CreateNewPostBottomSheet({
    Key? key,
    required this.forum,
    this.postEdit,
    required this.isOpenGalleryImmediately,
    required this.fromType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateNewPostBloc>(
      create: (ctx) => CreateNewPostBloc(
        forumRepository: RepositoryProvider.of<ForumRepository>(context),
        mediaRepository: RepositoryProvider.of<MediaRepository>(context),
        ssRepository: RepositoryProvider.of<SsRepository>(context),
        forum: forum,
        postEdit: postEdit,
        fromType: fromType,
      )..add(CreateNewPostInitialEvent(
          isOpenGallery: isOpenGalleryImmediately, initialPost: postEdit)),
      child: const CreateNewPostBottomSheetView(),
    );
  }
}

class CreateNewPostBottomSheetView extends StatefulWidget {
  const CreateNewPostBottomSheetView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateNewPostBottomSheetViewState();
}

class _CreateNewPostBottomSheetViewState
    extends State<CreateNewPostBottomSheetView> {
  late final TextEditingController _textEditingController;
  late CreateNewPostBloc _bloc;
  late final FocusNode _myFocusNode;

  final _picker = ImagePicker();
  double _fontSize = 16;
  bool isContentEmpty = true;
  Timer? _debounce;

  @override
  void initState() {
    _myFocusNode = FocusNode();
    _bloc = BlocProvider.of<CreateNewPostBloc>(context);
    setState(() {
      isContentEmpty = _bloc.postEdit == null;
    });
    _textEditingController =
        TextEditingController(text: _bloc.postEdit?.message ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    _bloc.close();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context),
      backgroundColor: ColorUtil.transparent,
      body: _buildBloc(),
    );
  }

  Widget _buildBloc() {
    return BlocConsumer<CreateNewPostBloc, CreateNewPostState>(
      listener: (ctx, state) async {
        if (state is CreateNewPostOpenGalleryState) {
          _onPressAttachPhoto();
        }
        if (state is NewFileState) {
          setState(() {});
        }

        if (state is CreateNewPostLoadingIndicatorState) {
          if (state.isLoading) {
            LoadingDialog.show(context, state.message);
          } else {
            Navigator.pop(context);
          }
        }

        if (state is UpdatePostSuccessfullyState) {
          if (state.isSuccess) {
            Navigator.pop(context);
            showSnackBarSuccess(
                context: context, message: l('Update post successfully'));
          } else {
            showSnackBarError(
                context: context,
                message: state.errorMessage ?? 'Something wrong');
          }
        }

        if (state is CreateNewPostSuccessfullyState) {
          if (state.isSuccess) {
            Navigator.pop(context);
            showSnackBarSuccess(
                context: context, message: l('Create post successfully'));
          } else {
            Navigator.pop(context);
            showSnackBarError(
                context: context,
                message: state.errorMessage ?? "Something wrong");
          }
        }
        if (state is CreateNewPostPopupUrlNotAllowState) {
          _alertUrlNotAllow(state.message);
        }
      },
      builder: (ctx, state) {
        return _buildBody(ctx, state);
      },
    );
  }

  _alertUrlNotAllow(String message) {
    CustomAlertDialog.show(
      context,
      title: l('Notify'),
      content: message,
      leftText: 'OK',
      isLeftPositive: true,
      leftAction: () {
        Navigator.pop(context);
      },
    );
  }

  Container _buildBody(BuildContext context, CreateNewPostState state) {
    final UserProfile? user = App.instance.userApp;
    return Container(
      decoration: const BoxDecoration(
        color: ColorUtil.backgroundItemColor,
      ),
      child: Column(
        children: [
          const Divider(color: ColorUtil.borderColor, height: 1.5),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  horizontal: MyStyles.horizontalMargin),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: ImageUtil.loadNetWorkImage(
                            url: App.instance.userApp?.avatar ?? '',
                            height: 45,
                            width: 45),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.getFullName() ?? '',
                              style: s(context, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            RichText(
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(children: [
                                  WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: ImageUtil.loadAssetsImage(
                                          fileName: 'ic_forum_fill.svg')),
                                  TextSpan(
                                      text: '  ${_bloc.forum.title} SuperFans',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: ColorUtil.textSecondaryColor))
                                ]))
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFieldDebounce(
                    focusNode: _myFocusNode,
                    controller: _textEditingController,
                    maxLines: null,
                    minLines: 20,
                    onChanged: (s) {
                      setState(() {
                        _fontSize = s.trim().length > 100 ? 12 : 17;
                        isContentEmpty = s.trim().isEmpty;
                      });
                    },
                    onChangedDebounce: (String s) {
                      final url = s.getFirstUrl();
                      if (url.isEmpty) {
                        _bloc.add(const CreateNewPostSetIsHaveUrlEvent(
                            isHaveUrl: false));
                      }
                      if (!_bloc.isHaveUrl && url.isNotEmpty) {
                        _bloc.add(CreateNewPostGetInfoUrlEvent(url: url));
                      }
                    },
                    style: TextStyle(fontSize: _fontSize),
                    decoration: InputDecoration.collapsed(
                        hintText: l('Write something') + ' ...',
                        hintStyle: const TextStyle(
                            color: ColorUtil.textSecondaryColor)),
                  ),
                ],
              ),
            ),
          ),
          if (_bloc.listFilePicked.isEmpty)
            (state is CreateNewPostGetInfoUrlLoadingState && state.isLoading)
                ? const IndicatorLoadMore()
                : _bloc.graphUrlInfo != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: MyStyles.horizontalMargin),
                        child: UrlPreviewWidget(
                          graphUrlInfo: _bloc.graphUrlInfo!,
                          type: UrlPreviewWidgetType.typeEdit,
                          removeGraphUrlInfo: () {
                            _bloc.add(CreateNewPostRemoveGraphInfoUrlEvent());
                          },
                        ),
                      )
                    : const SizedBox(),

          /// ATTACHED FILE
          // TODO CHECK ITEM COUNT
          Visibility(
            visible: _bloc.listFilePicked.isNotEmpty,
            child: GridView.count(
              crossAxisCount: (maxLengthFile / 2).round(),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _bloc.listFilePicked.map((item) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    item.mediaExist != null
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ImageUtil.loadNetWorkImage(
                                    url: item.mediaExist?.thumb ?? '',
                                    height: 500,
                                    width: 500)),
                          )
                        : const SizedBox(),
                    item.photoAsset != null
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: AssetThumb(
                                  asset: item.photoAsset!,
                                  height: 500,
                                  width: 500,
                                  quality: 100,
                                )),
                          )
                        : const SizedBox(),
                    item.videoFile != null
                        ? Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item.videoThumb != null
                                  ? Image.memory(item.videoThumb!,
                                      height: 80, width: 80, fit: BoxFit.cover)
                                  : const IndicatorLoadMore(),
                            ),
                          )
                        : const SizedBox(),
                    (item.videoFile != null || item.mediaExist?.type == 'video')
                        ? BuildBtnPlayVideo(
                            context: context,
                            onPress: () => {},
                            path: "ic_play_thumbnail_file.svg",
                            size: 30)
                        : const SizedBox(),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => _onRemoveFilePicked(item),
                        child: ImageUtil.loadAssetsImage(
                            fileName: 'ic_remove_file.svg'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            replacement: const SizedBox(),
          ),

          Container(
            margin: const EdgeInsets.all(MyStyles.horizontalMargin),
            child: Row(
              children: [
                _itemAttach(
                    icon: 'ic_attach_photo.svg',
                    text: l('Photo'),
                    onPress: _onPressAttachPhoto),
                const SizedBox(width: 8),
                _itemAttach(
                    icon: 'ic_attach_video.svg',
                    text: l('Video'),
                    onPress: _onPressAttachVideo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _itemAttach(
      {required String text,
      required String icon,
      required void Function() onPress}) {
    return Expanded(
      child: InkClickItem(
        onTap: onPress,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff5371D7)),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ImageUtil.loadAssetsImage(
                fileName: icon, color: ColorUtil.colorButton),
            const SizedBox(width: 8),
            Text(
              text,
              style: s(context,
                  color: ColorUtil.colorButton,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),
          ]),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return S2EAppBar(
      title: _bloc.postEdit != null ? l('Update post') : l('Create post'),
      backgroundColor: ColorUtil.backgroundItemColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      leadWidget: IconButton(
        onPressed: () {
          _myFocusNode.unfocus();
          Navigator.pop(context);
        },
        icon: ImageUtil.loadAssetsImage(
            fileName: 'ic_close_dialog_white.svg', width: 18, height: 18),
      ),
      actionWidgets: [
        GradientButton(
          onPressed: _conditionSubmit() ? _onPressSubmit : null,
          text: _bloc.postEdit != null ? l('Save') : l('Post'),
          titleStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          width: 100,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          colors: _conditionSubmit()
              ? ColorUtil.defaultGradientButton
              : ColorUtil.buttonDisabled,
        ),
      ],
    );
  }

  _onPressSubmit() {
    _myFocusNode.unfocus();
    for (var element in _bloc.graphBlacklistDomains) {
      if (_textEditingController.text.contains(element)) {
        _alertUrlNotAllow(l('Content that violates our community standards'));
        return;
      }
    }
    if (_bloc.postEdit != null) {
      _bloc.add(ActionUpdatePostEvent(message: _textEditingController.text));
    } else {
      _bloc.add(ActionCreateNewPostEvent(message: _textEditingController.text));
    }
  }

  bool _conditionSubmit() => !isContentEmpty || _bloc.listFilePicked.isNotEmpty;

  _onPressAttachVideo() async {
    if (_bloc.listFilePicked.length < maxLengthFile) {
      File? file = await onGetVideo(context: context, picker: _picker);
      if (file != null) {
        _bloc.add(GetVideoFromGallerySuccessEvent(file: file));
      }
    } else {
      showSnackBarError(
          context: context, message: l('You can only select up to 8 files'));
    }
  }

  _onPressAttachPhoto() async {
    if (_bloc.listFilePicked.length < maxLengthFile) {
      final List<Asset> listImageAsset = [];
      for (var element in _bloc.listFilePicked) {
        if (element.photoAsset != null) {
          listImageAsset.add(element.photoAsset!);
        }
      }
      List<Asset>? assets = await onGetMultiImagePicker(
          context: context,
          selectedAssets: listImageAsset,
          maxImages: _bloc.getMaxLengthPhotoCanSelected(maxLengthFile));
      if (assets != null) {
        _bloc.add(CreateNewPostGetImageFromGallerySuccessEvent(
            assetsPickerList: assets));
      }
    } else {
      showSnackBarError(
          context: context, message: l('You can only select up to 8 files'));
    }
  }

  _onRemoveFilePicked(FilePickerModel file) {
    _bloc.add(RemoveFilePickedEvent(item: file));
  }
}
