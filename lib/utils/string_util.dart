import 'package:sing_app/utils/date_util.dart';

import '../config/app_localization.dart';
import '../data/models/post.dart';

class StringUtil {
  static String getPositionAndTimePost(Post item) =>
      '${item.user.getPosition()} ${item.createdAt.convertCovalentDateToTimeHasPass()}';

  static String getPositionAndTimePinnedPost(Post item) =>
      '${item.user.getPosition()} ${item.createdAt.convertCovalentDateToTimeHasPass(isShort: true)} ${l('ago')}';

  static String getDurationTimeInMinute(
      {required int seconds, String separatorCharacter = ':'}) {
    String getParsedTime(int time) {
      if (time <= 9) return "0$time";
      return time.toString();
    }

    int sec = seconds % 60;
    int min = seconds ~/ 60;
    int hour = min ~/ 60;
    if (hour > 0) {
      return getParsedTime(hour) +
          separatorCharacter +
          getParsedTime(min) +
          separatorCharacter +
          getParsedTime(sec);
    } else {
      return getParsedTime(min) + separatorCharacter + getParsedTime(sec);
    }
  }
}
