import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/video_player/video_player_bloc.dart';
import 'package:sing_app/blocs/video_player/video_player_state.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/covalent_nft.dart';
import 'package:sing_app/data/models/moralis_nft.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/logger_util.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  const VideoPlayerScreen({Key? key, this.args}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerBloc _videoPlayerBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  MoralisNft? _nft;

  @override
  void initState() {
    _videoPlayerBloc = BlocProvider.of<VideoPlayerBloc>(context);
    _nft = widget.args?['nft'];

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoPlayerBloc, VideoPlayerState>(
      listener: (ctx, state) {
        LoggerUtil.info('video player screen state: $state');
      },
      builder: (ctx, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(),
          body: _buildBody(context),
        );
      },
    );
  }

  _buildBody(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer.network(
              'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4',
            ),
          ),
        ));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: systemUiOverlayStyle,
        leading: IconButton(
          icon: ImageUtil.loadAssetsImage(fileName: 'ic_back.svg'),
          onPressed: () => Navigator.of(context).pop(),
        ));
  }
}
