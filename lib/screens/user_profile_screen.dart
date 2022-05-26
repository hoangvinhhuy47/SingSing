import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sing_app/blocs/profile/profile_screen_bloc.dart';
import 'package:sing_app/blocs/profile/profile_screen_event.dart';
import 'package:sing_app/blocs/profile/profile_screen_state.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/theme_util.dart';
import 'package:sing_app/widgets/login_register_view.dart';

import '../application.dart';
import '../constants/constants.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late ProfileScreenBloc _userProfileScreenBloc;
  final _picker = ImagePicker();

  late StreamSubscription _changeUserInfoListener;
  late StreamSubscription _onChangedLanguageListener;

  @override
  void initState() {
    _userProfileScreenBloc = BlocProvider.of<ProfileScreenBloc>(context);

    _changeUserInfoListener = App.instance.eventBus.on<EventBusChangeUserInfoSuccessful>().listen((event) {
      _userProfileScreenBloc.add(ChangeUserInfoSuccessfulEvent(email: event.email));
    });
    _onChangedLanguageListener = App.instance.eventBus.on<EventChangedLanguage>().listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _userProfileScreenBloc.close();
    _changeUserInfoListener.cancel();
    _onChangedLanguageListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: _buildAppBar(),
        body: _buildBloc(context)
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: ColorUtil.backgroundPrimary,
      systemOverlayStyle: systemUiOverlayStyle,
      elevation: 0.0,
      leading: IconButton(
        icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
        tooltip: l('Back'),
        onPressed: () =>
            Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildBloc(BuildContext context) {
    return BlocConsumer<ProfileScreenBloc, ProfileScreenState>(
      listener: (ctx, state) {
        if(state is ProfileScreenStateLoggingOut){
          final alert = AlertDialog(
            backgroundColor: Colors.transparent,
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SpinKitRing(
                  color: Colors.white,
                  lineWidth: 2,
                  size: 32,
                ),
                Container(margin: const EdgeInsets.only(left: 7),
                    child: Text(l("Logging out..."),
                        style: const TextStyle(color: ColorUtil.white)
                    )),
              ],
            ),
          );
          showDialog(barrierDismissible: false,
            context:context,
            builder:(BuildContext context){
              return alert;
            },
          );
        } else if(state is ProfileScreenStateLoggedOut){
          App.instance.currentWallet = null;
          App.instance.allBalances = [];
          App.instance.availableBalances = [];
          Navigator.popUntil(context, (route) => route.isFirst);
          _userProfileScreenBloc.rootBloc.add(LoggedOut());
        } else if(state is ProfileScreenStateUploadAvatarError){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l('Upload avatar error'))),
          );
        } else if(state is ProfileScreenStateUploadCoverError) {
          showSnackBarError(context: context, message: state.message);
        }
      },
      buildWhen: (preState, nextState) {
        return nextState is! ProfileScreenStateLoggedOut;
      },
      builder: (ctx, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(ProfileScreenState state) {
    if(state is ProfileScreenStateLoading && state.showLoading){
      return const SpinKitRing(
        color: Colors.white,
        lineWidth: 2,
        size: 32,
      );
    }

    if(App.instance.isLoggedIn){
      return _buildAuthView();
    }
    return Container();
  }

  _buildAuthView(){
    return Column(children: [

      Expanded(child: ListView(
        // padding: const EdgeInsets.all(MyStyles.horizontalMargin),
        children: [
          _buildUserHeader(),
          const SizedBox(height: MyStyles.horizontalMargin),
          _buildListViewHeader(l('Account')),
          const SizedBox(height: MyStyles.horizontalMargin),
          // _buildListViewItem(
          //   icon: 'ic_edit_profile.svg',
          //   title: l('Edit profile'),
          //   onPressed: () async {
          //     final updated = await Navigator.pushNamed(context, Routes.editProfileScreen);
          //     // if(updated == true){
          //     //   _userProfileScreenBloc.add(ProfileScreenEventReload());
          //     // }
          //   },
          // ),
          // _buildListViewItem(
          //   icon: 'ic_change_password.svg',
          //   title: l('Change password'),
          //   onPressed: () async {
          //     Navigator.pushNamed(context, Routes.changePasswordScreen);
          //   },
          // ),
          // _buildListViewItem(
          //   icon: 'ic_change_email.svg',
          //   title: l('Change email'),
          //   onPressed: () async {
          //     Navigator.pushNamed(context, Routes.changeEmailScreen);
          //   },
          // ),
          // _buildListViewItem(
          //   icon: 'ic_lock_app.svg',
          //   title: l('Security'),
          //   onPressed: () async {
          //     // FirebaseCrashlytics.instance.crash();
          //     Navigator.pushNamed(context, Routes.settingSecurityScreen);
          //   },
          // ),
          // const SizedBox(height: MyStyles.horizontalMargin,),
          // _buildListViewHeader(l('Others')),
          const SizedBox(height: MyStyles.horizontalMargin,),
          // _buildLanguageRow(),
          _buildListViewItem(
            icon: 'ic_logout.svg',
            title: l('Logout'),
            rightArrow: false,
            onPressed: () async {
              _userProfileScreenBloc.add(ProfileScreenEventLogout());
            },
          ),

        ],
      )),
      _buildAppVersion(),

    ],);
  }

  _buildAppVersion() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
          '${App.instance.appName}: ${App.instance.appVersion} (${App.instance.appBuildNumber})',
          style: s(context, fontSize: 16, color: ColorUtil.white)
      ),
    );
  }

  _buildListViewHeader(String title){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: MyStyles.horizontalMargin),
      child: Text(title.toUpperCase(),
        style: const TextStyle(
            color: ColorUtil.lightGrey,
            fontSize: 16
        ),
      ),
    );
  }


  _buildListViewItem({required String icon, required String title, required void Function() onPressed, bool rightArrow = true}){
    return Material(
      child: Ink(
        decoration: const BoxDecoration(
          color: ColorUtil.backgroundSecondary,
        ),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 16, 16),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: ImageUtil.loadAssetsImage(
                      fileName: icon, height: 18,
                      color: ColorUtil.lightGrey,
                      fit: BoxFit.scaleDown
                  ),
                ),
                Expanded(child: Padding(
                    padding: const EdgeInsets.only(
                        left: MyStyles.horizontalMargin,
                        right: MyStyles.horizontalMargin),
                    child: Text(
                      title,
                      style: const TextStyle(color: ColorUtil.lightGrey, fontSize: 16),
                    ),
                  ),
                ),
                if(rightArrow)
                  ImageUtil.loadAssetsImage(fileName: 'ic_arrow_right.svg', color: const Color(0xFF7E90A1)),
              ],
            ),
          ),
          onTap: onPressed,
        ),
      ),
    );
  }

  _buildLanguageRow(){
    return Material(
      child: Ink(
        decoration: const BoxDecoration(
          color: ColorUtil.primary,
        ),
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 16, 16),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 12,
                  child: ImageUtil.loadAssetsImage(
                      fileName: AppLocalization.instance.currentLangCode == LangCode.en ? 'en.png' : 'vn.png',
                      height: 12,
                      width: 18
                  ),
                ),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(
                      left: MyStyles.horizontalMargin,
                      right: MyStyles.horizontalMargin),
                  child: Text(
                    l('Language'),
                    style: const TextStyle(color: ColorUtil.lightGrey, fontSize: 16),
                  ),
                ),
                ),
                ImageUtil.loadAssetsImage(fileName: 'ic_arrow_right.svg', color: const Color(0xFF7E90A1)),
              ],
            ),
          ),
          onTap: () {
              Navigator.pushNamed(context, Routes.selectLanguageScreen);
            },
        ),
      ),
    );
  }

  _buildUserHeader(){
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 180,
            child: ImageUtil.loadNetWorkImage(url: _userProfileScreenBloc.userProfile?.cover ?? '',
                height: 180,
                fit: BoxFit.fitWidth,
                placeHolder: assetImg('user_profile_banner.png')
            ),
          ),
          // Positioned(
          //   right: 8,
          //   child: _buildEditCoverButton(),
          // ),
          Center(
            child: _buildUsernameAndAvatar(),
          )
        ],
      ),
    );
  }

  _buildEditCoverButton(){
    return TextButton(
      onPressed: _onCoverEditButtonPressed,
      style: ButtonStyle(
          overlayColor:  MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.3)),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
              )
          ),
          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF161B2E).withOpacity(0.5)),
      ),
      child: SizedBox(
        width: 75,
        height: 32,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageUtil.loadAssetsImage(fileName: 'ic_edit.svg', width: 16, fit: BoxFit.contain),
              const SizedBox(width: 8,),
              Text(l('Edit'),
                style: const TextStyle(color: Colors.white, fontSize: 13),
              )
            ]
        ),
      ),
    );
  }

  _buildUsernameAndAvatar(){
    return Row(
      children: [
        const SizedBox(width: MyStyles.horizontalMargin * 2,),
        _buildAvatar(),
        const SizedBox(width: MyStyles.horizontalMargin,),
        Expanded(child: Wrap(children: [_buildUsername()],),),
        const SizedBox(width: MyStyles.horizontalMargin,),
      ],
    );
  }

  static const avatarHeight = 80.0;

  Widget _avatar() {
    if(_userProfileScreenBloc.fileUploadAvatar != null){
      return Image.file(_userProfileScreenBloc.fileUploadAvatar!, height: avatarHeight, width: avatarHeight, fit: BoxFit.cover);
    } else {
      return ImageUtil.loadNetWorkImage(
          url: App.instance.userApp?.avatar ?? '', height: avatarHeight, width: avatarHeight,
          placeHolder: assetImg('ic_user_profile.svg')
      );
    }
  }

  _buildAvatar(){
    return Stack(children: [
      Container(
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xffBF26E5), Color(0xff3C14DA)]),
          borderRadius: BorderRadius.circular(avatarHeight/2),
        ),
        child: Container(
          width: avatarHeight,
          height: avatarHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(avatarHeight/2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(avatarHeight/2),
            child: _avatar()
          ),
        ),
      ),
      // Positioned(
      //   bottom: 0,
      //   right: 0,
      //   child: _buildAvatarEditButton(),
      // ),
    ],);
  }

  _buildAvatarEditButton(){
    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xffBF26E5), Color(0xff3C14DA)]),
        borderRadius: BorderRadius.circular(32/2),
      ),
      child:TextButton(onPressed: _onAvatarEditButtonPressed,
        style: ButtonStyle(
          overlayColor:  MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.3)),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          shape: MaterialStateProperty.all<CircleBorder>(const CircleBorder()),
          backgroundColor: MaterialStateProperty.all<Color>(ColorUtil.primary),
        ),
        child: SizedBox(
          width: 12,
          height: 12,
          child: ImageUtil.loadAssetsImage(fileName: 'ic_edit.svg', width: 12, fit: BoxFit.scaleDown),
        ),
      )
    );
  }

  _buildUsername() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(7)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 13, 18, 13),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText('@${App.instance.userApp?.username}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            maxFontSize: 18,
            minFontSize: 13,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: MyFontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(App.instance.userApp?.email ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _onAvatarEditButtonPressed() async {
    if (await Permission.photos.request().isGranted) {
      try {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
        );

        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          int sizeInBytes = imageFile.lengthSync();
          double sizeInMb = sizeInBytes / (1024 * 1024);
          if (sizeInMb > 2){
            showSnackBarError(context: context, message: l('File size is less than or equal to 2MB'));
            return;
          }
          _userProfileScreenBloc.add(ProfileScreenEventUploadAvatar(file: imageFile, mimeType: pickedFile.mimeType ?? ''));
          return;
        } else {
          showSnackBarError(context: context, message: 'File error');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else {
      _showPhotoPermissionAlertDialog();
    }
  }

  void _onCoverEditButtonPressed() async {
    if (await Permission.photos.request().isGranted) {
      try {
        final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
        );

        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          int sizeInBytes = imageFile.lengthSync();
          double sizeInMb = sizeInBytes / (1024 * 1024);
          if (sizeInMb > 2){
            showSnackBarError(context: context, message: l('File size is less than or equal to 2MB'));
            return;
          }

          _userProfileScreenBloc.add(ProfileScreenEventUploadCover(file: imageFile, mimeType: pickedFile.mimeType ?? ''));
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else {
      _showPhotoPermissionAlertDialog();
    }
  }

  _showPhotoPermissionAlertDialog() {
    // set up the buttons
    final cancelButton = TextButton(
      child: Text(l("Cancel")),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    final settingsButton = TextButton(
      child: Text(l("Settings")),
      onPressed:  () {
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


}
