import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/song_model.dart';
import 'package:sing_app/routes.dart';
import 'package:sing_app/utils/check_permisstion.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/border_outline.dart';

import 'package:sing_app/widgets/ink_click_item.dart';
import 'package:sing_app/widgets/radius_widget.dart';
import '../../utils/string_util.dart';

Future<void> alertSongDemo(BuildContext context, SongModel? songModel) {
  return showDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6),
      barrierDismissible: false,
      builder: (ctx) {
        return AlertSongDemo(
          songModel: songModel,
        );
      });
}

enum ActionSong { play, pause, stop }

class AlertSongDemo extends StatefulWidget {
  const AlertSongDemo({Key? key, required this.songModel}) : super(key: key);

  @override
  State<AlertSongDemo> createState() => _AlertSongDemo();
  final SongModel? songModel;
}

class _AlertSongDemo extends State<AlertSongDemo> {
  late double radiusBox = 5.0;
  late int maxValue = 90;
  late int value = 0;
  late ActionSong checkPlay = ActionSong.pause;
  late Timer? _time;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 40;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: RadiusWidget(
        color: ColorUtil.deepPurple,
        width: width,
        height: 350,
        padding: const EdgeInsets.symmetric(vertical: 5),
        borderRadius: BorderRadius.circular(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_buildHeader(), _buildBody(), _buildButton()],
        ),
      )),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 35,
          ),
          Text(
            "You're playing demo",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: s(context,
                fontSize: 13,
                color: ColorUtil.white,
                fontWeight: FontWeight.w400),
          ),
          InkClickItem(
            padding: const EdgeInsets.all(15),
            onTap: () {
              Navigator.pop(context);
            },
            child: ImageUtil.loadAssetsImage(
                fileName: 'btn_close.svg',
                width: 14,
                height: 14,
                color: ColorUtil.white),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    double width = MediaQuery.of(context).size.width - 40;
    return Container(
      height: 220,
      width: width,
      color: ColorUtil.backgroundPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildOptionSing(), _buildLineSing(), _buildImageSing()],
      ),
    );
  }

  Widget _buildOptionSing() {
    double width = MediaQuery.of(context).size.width - 40;
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: width - 190,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "8s",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 11,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                "8s",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 11,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: width - 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (value >= 8) {
                      value = value - 8;
                    }
                  });
                },
                child: ImageUtil.loadAssetsImage(
                    fileName: 'btn_rewind.svg',
                    width: 23,
                    height: 21,
                    color: ColorUtil.white),
              ),
              GestureDetector(
                onTap: () {
                  _playSongDemo();
                },
                child: ImageUtil.loadAssetsImage(
                    fileName: checkPlay != ActionSong.play
                        ? 'btn_play_music.svg'
                        : 'btn_pause_music.svg',
                    width: 23,
                    height: 23,
                    color: ColorUtil.white),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (maxValue - value >= 8) {
                      value = value + 8;
                    }
                  });
                },
                child: ImageUtil.loadAssetsImage(
                    fileName: 'btn_forward.svg',
                    width: 23,
                    height: 21,
                    color: ColorUtil.white),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column _buildLineSing() {
    double width = MediaQuery.of(context).size.width - 40;
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${StringUtil.getDurationTimeInMinute(seconds: value)} ',
                style: s(context, fontSize: 14),
              ),
              Text(
                StringUtil.getDurationTimeInMinute(seconds: maxValue),
                style: s(context, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 10,
          width: width - 10,
          child: Slider(
            value: value.toDouble(),
            onChanged: (val) {
              _changeToSecond(val.toInt());
            },
            activeColor: ColorUtil.cyan,
            min: 0,
            max: maxValue.toDouble(),
            inactiveColor: ColorUtil.primary,
          ),
        )
      ],
    );
  }

  Widget _buildImageSing() {
    late double photoSize = 71.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: ImageUtil.loadNetWorkImage(
                url: tempUrl,
                width: photoSize,
                height: photoSize,
                fit: BoxFit.cover),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bài hát cho em",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 16,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Khánh Linh",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: s(context,
                    fontSize: 11,
                    color: ColorUtil.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButton() {
    double width = MediaQuery.of(context).size.width - 40;
    return GestureDetector(
        onTap: () {
          checkPermission(
              context,
              () => Navigator.pushNamed(context, Routes.singToEarnScreen,
                      arguments: {
                        SingToEarnScreenArgs.songModel: widget.songModel
                      }));
        },
        child: BorderOutLine(
          margin: const EdgeInsets.only(top: 20),
          colorOutline: ColorUtil.primary,
          backgroundItem: ColorUtil.primary,
          height: 40,
          width: width - 80,
          alignment: Alignment.center,
          borderRadius: BorderRadius.circular(25),
          child: Text(
            "Sing to earn",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: s(context,
                fontSize: 16,
                color: ColorUtil.white,
                fontWeight: FontWeight.w400),
          ),
        ));
  }

  void _changeToSecond(int second) {
    setState(() {
      value = second;
    });
  }

  void _playSongDemo() {
    if (checkPlay == ActionSong.pause) {
      setState(() {
        checkPlay = ActionSong.play;
      });
      if (checkPlay == ActionSong.play) {
        _time = Timer.periodic(const Duration(seconds: 1), (_) {
          if (value < maxValue) {
            setState(() {
              value++;
            });
          } else {
            setState(() {
              checkPlay = ActionSong.stop;
            });
          }
        });
      }
    } else if (checkPlay == ActionSong.stop) {
      setState(() {
        value = 0;
        checkPlay = ActionSong.play;
      });
    } else if (checkPlay == ActionSong.play) {
      setState(() {
        _time!.cancel();
        checkPlay = ActionSong.pause;
      });
    }
  }
}
