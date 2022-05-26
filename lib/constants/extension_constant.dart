import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';


extension TypeUpdateExtension on TypeUpdateApp {
  int get value {
    switch (this) {
      case TypeUpdateApp.noUpdate:
        return 0;
      case TypeUpdateApp.update:
        return 1;
      case TypeUpdateApp.forceUpdate:
        return 2;
      default:
        return 0;
    }
  }
}

extension ActionDialogExtension on ActionsDialog {
  String get value {
    switch (this) {
      case ActionsDialog.pin:
        return l("Pin");
      case ActionsDialog.unPin:
        return l("Unpin");
      case ActionsDialog.edit:
        return l("Edit");
      case ActionsDialog.delete:
        return l("Delete");
      case ActionsDialog.cancel:
        return l("Cancel");
      case ActionsDialog.report:
        return l("Report");
      default:
        return "";
    }
  }
}

extension TypeUserExtension on UserType {
  int get value {
    switch (this) {
      case UserType.normal:
        return 0;
      case UserType.mod:
        return 1;
      case UserType.admin:
        return 2;
      default:
        return -1;
    }
  }
}

extension LocalAuthScreenSettingArgsExtension on LocalAuthScreenSettingArgs {
  String get value {
    switch (this) {
      case LocalAuthScreenSettingArgs.isPasscodeCorrect:
        return 'isPasscodeCorrect';
    }
  }
}

extension ArticleTypeExtension on ArticleType {
  String get title {
    switch (this) {
      case ArticleType.whatIsSecretPhrase:
        return l('What is Secret Phrase');
      case ArticleType.privacyPolicy:
        return l('Privacy policy');
      case ArticleType.termAndService:
        return l('Term of services');
    }
  }
}

extension SingScoreRangeTypeExtension on SingScoreRangeType {
  String get scoreRange {
    switch (this) {
      case SingScoreRangeType.bad:
        return "< 50";
      case SingScoreRangeType.great:
        return "50 - 60";
      case SingScoreRangeType.awesome:
        return "60 - 80";
      case SingScoreRangeType.perfect:
        return ">80";
    }
  }

  String get toEarn {
    switch (this) {
      case SingScoreRangeType.bad:
        return ":( Sorry, Keep going";
      case SingScoreRangeType.great:
        return "Great, 1";
      case SingScoreRangeType.awesome:
        return "Awesome, 2";
      case SingScoreRangeType.perfect:
        return "Perfect, 3";
    }
  }
}

extension MicAttributeTypeExtension on MicAttributeType {
  String get attributes {
    switch (this) {
      case MicAttributeType.durability:
        return 'Durability';
      case MicAttributeType.luck:
        return 'Luck';
      case MicAttributeType.s2ePerDay:
        return 'Number of S2E per day';
      case MicAttributeType.quantity:
        return 'Quantity';
    }
  }

  String get pathMicAttributeIcon {
    switch (this) {
      case MicAttributeType.durability:
        return 'ic_durability.svg';
      case MicAttributeType.luck:
        return 'ic_star.svg';
      case MicAttributeType.s2ePerDay:
        return '';
      case MicAttributeType.quantity:
        return '';
    }
  }
}

extension NftS2ERankExtension on NftS2ERank {
  int get value {
    switch (this) {
      case NftS2ERank.bronze:
        return 0;
      case NftS2ERank.silver:
        return 1;
      case NftS2ERank.gold:
        return 2;
    }
  }
}

