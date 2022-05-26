import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_outline.dart';
import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/radius_widget.dart';

class Constants {
  static const double tokenIconSize = 42;
  static const String isFirstLaunchKey = 'isFirstLaunchKey';
  static const shortAnimationDuration = 300;
  static const longAnimationDuration = 500;
  static const debounceClick = 500;
  static const defaultApiLimit = 20;
}

const String secretTypeBsc = 'BSC';
const String tokenSymbolBnb = 'BNB';
const String tokenSymbolEth = 'ETH';
const String secretTypeEth = 'ETHEREUM';
const String cKey = 'ckey_7a784d52476841a6a2cb5ca4807';
const String bscScanApiKey = 'MHM2P4GNW2B7PQK6D2XY9SGUVWVX3N7X9E';
const String moralisApiKey =
    '58cpcahxsaXORX2cevfGAh0dFelIpMttiyB1NnlLZQNHDjI1cXHRRvnOfnR7eURS';

const String ssoClientId = 'cms-singsing';

const String storageKeyPasscode = 'storage_key_passcode';
const String storageKeyEnableAppLock = 'storage_key_enable_app_lock';
const String storageKeyAutoLockDuration = 'storage_key_auto_lock_duration';
const String storageKeyLockMethod = 'storage_key_lock_method';
const String storageKeyEnableTransactionSigning =
    'storage_key_enable_transaction_signing';
const String storageKeyUserProfileApp = 'storage_key_user_profile_app';

const systemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: ColorUtil.backgroundPrimary,
  statusBarIconBrightness: Brightness.light, // For Android
  statusBarBrightness: Brightness.dark, // For iOS
);

const orangeUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: ColorUtil.orange,
  statusBarIconBrightness: Brightness.light, // For Android
  statusBarBrightness: Brightness.dark, // For iOS
);

enum TypeUpdateApp {
  noUpdate,
  update,
  forceUpdate,
}

enum PostDetailScreenArgs {
  isFocusCommentField,
  isOpenGallery,
  post,
  forum,
  postId
}
enum ForumDetailScreenArgs { forum }
enum ForumMemberScreenArgs { forum, initMember }
enum ForumSearchScreenArgs { initialForums, initialTotal }
enum PreviewImageScreenArgs { medias, initialIndex, singleImage }
enum LocalAuthScreenSettingArgs { isPasscodeCorrect }
enum LocalAuthScreenArgs { isWaitingDisableLocalAuth, canBack }
enum ArticleScreenArgs { articleType }
enum SongDetailScreenArgs { songModel }
enum TransactionHistoryScreenArgs { wallet }

enum DetailNftS2EScreenArgs { micModel,superPassModel }
enum SingToEarnScreenArgs { songModel }

enum ActionsDialog {
  pin,
  unPin,
  edit,
  delete,
  cancel,
  report,
}

enum UserType {
  normal,
  mod,
  admin,
}

enum FileCheck {
  notAllowSizePhoto,
  notAllowSizeVideo,
  notAllowFilePhoto,
  notAllowFileVideo,
  allow,
}

enum FileType { photo, video }

enum CommentState { posting, error }

enum UrlPreviewWidgetType { typeView, typeEdit, typePinPost, typeLinkInComment }

enum CreateNewPostBottomSheetFromType { forumDetail, postDetail }

enum ArticleType { whatIsSecretPhrase, privacyPolicy, termAndService }

enum MicType { inMarket,detailMarket }
enum SingScoreRangeType { bad, great, awesome, perfect }
enum MicAttributeType { durability, luck,s2ePerDay,quantity }
enum NftS2ERank { bronze, silver, gold }
enum ItemSongType { songDetail, songResult }

const String tempUrl =
    "https://event.mediacdn.vn/2020/9/11/bray-1-15998125670871089915520.png";


