import 'package:flutter/services.dart';
import 'package:sing_app/utils/color_util.dart';

class Constants {
  static const double tokenIconSize = 42;
  static const String isFirstLaunchKey = 'isFirstLaunchKey';
}

const String secretTypeBsc = 'BSC';
const String secretTypeEth = 'ETHEREUM';
const String cKey = 'ckey_7a784d52476841a6a2cb5ca4807';
const String bscScanApiKey = 'MHM2P4GNW2B7PQK6D2XY9SGUVWVX3N7X9E';
const String moralisApiKey = '58cpcahxsaXORX2cevfGAh0dFelIpMttiyB1NnlLZQNHDjI1cXHRRvnOfnR7eURS';

// const String singSingTokenAddress = '0xEc3b10C74Fa75576874151872F3D002134E48B37';
// const String singSingV2TokenAddress = '0x3fA5b7295067255Cf17fe5ac499E92e8bEEC0b9E';


const String ssoClientId = 'cms-singsing';


const systemUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: ColorUtil.primary,
  statusBarIconBrightness: Brightness.light, // For Android
  statusBarBrightness: Brightness.dark, // For iOS
);
