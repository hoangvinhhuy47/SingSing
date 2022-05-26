import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/sing/calculate_score_s2e/calculate_score_s2e_screen_bloc.dart';
import 'package:sing_app/blocs/sing/calculate_score_s2e/calculate_score_s2e_screen_state.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/image_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/utils/theme_util.dart';

import '../../constants/constants.dart';
import '../../routes.dart';

class CalculateScoreS2EScreen extends StatefulWidget {
  const CalculateScoreS2EScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CalculateScoreS2EScreenState();
}

class _CalculateScoreS2EScreenState extends State<CalculateScoreS2EScreen> {
  late CalculateScoreS2EScreenBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalculateScoreS2EScreenBloc,
        CalculateScoreS2EScreenState>(
      builder: _buildBody,
      listener: (BuildContext context, state) {
        if (state is CalculateScoreS2EDoneState && state.isSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.singResultScreen,
              (r) => r.settings.name == Routes.songDetailScreen,
              arguments: {SingToEarnScreenArgs.songModel: _bloc.songModel});
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, state) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Calculating your score',
                style: s(context,
                    fontSize: 24,
                    color: ColorUtil.grey100,
                    fontWeight: MyFontWeight.bold),
              ),
              ImageUtil.loadLottieAnimation(
                fileName: 'assets/lottie/loading.json',
                fullPath: true,
              ),
              Text(
                'Please wait for AI assessment ,\nIt can take up to 2 minutes',
                textAlign: TextAlign.center,
                style: s(context, color: ColorUtil.grey100, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}
