

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sing_app/data/models/word_lyric.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/parse_util.dart';

class LyricUtil {
  static Future<List<SentenceLyric>> loadSongLyric({
    required BuildContext context,
    required String filePath,
  }) async {
    List<SentenceLyric> sentenceLyric = [];


    String songLyricData = await DefaultAssetBundle.of(context).loadString(filePath);


    LineSplitter ls = const LineSplitter();
    List<String> words = ls.convert(songLyricData);

    List<WordLyric> lineLyrics = [];

    for(String word in words) {
      final wordInfos = word.split(',');
      if(wordInfos.length >= 3) {
        double startTime = 0;
        double endTime = 0;

        String startTimeString = wordInfos[0].trim();
        if(startTimeString.startsWith('\'') && startTimeString.endsWith('\'')) {
          startTimeString = startTimeString.substring(1, startTimeString.length - 2);
        }
        final listStartTimeString = startTimeString.split(':');
        if(listStartTimeString.length == 2) {
          startTime = Parse.toDoubleValue(listStartTimeString[0]) * 60 + Parse.toDoubleValue(listStartTimeString[1]);
        }

        String endTimeString = wordInfos[1].trim();
        if(endTimeString.startsWith('\'') && endTimeString.endsWith('\'')) {
          endTimeString = endTimeString.substring(1, endTimeString.length - 2);
        }
        final listEndTimeString = startTimeString.split(':');
        if(listEndTimeString.length == 2) {
          endTime = Parse.toDoubleValue(listEndTimeString[0]) * 60 + Parse.toDoubleValue(listEndTimeString[1]);
        }

        String word = wordInfos[2].trim();
        if(word.startsWith('\'[') && word.endsWith(']\'')) {
          word = word.substring(2, word.length - 2);
        }
        lineLyrics.add(WordLyric(word: word, startTime: startTime, endTime: endTime));
        if(!word.endsWith(' ')) {
          sentenceLyric.add(SentenceLyric(wordLyrics: [...lineLyrics]));
          lineLyrics = [];
        }
      }
    }

    String line = '';
    for(SentenceLyric sLyric in sentenceLyric) {
      final wLyrics = sLyric.wordLyrics;

      for(WordLyric w in wLyrics) {
        line = line + w.word;
        // LoggerUtil.info('word: ${w.word} - line: $line');
      }
      LoggerUtil.info('line: $line');
      line = '';
    }

    // use AnimatedContainer

    return sentenceLyric;
  }
}
