import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/widgets/loading_indicator.dart';
import 'package:sing_app/widgets/no_internet_widget.dart';

import '../../application.dart';
import '../../blocs/auth_screen/auth_screen_bloc.dart';
import '../../blocs/auth_screen/auth_screen_event.dart';
import '../../blocs/auth_screen/auth_screen_state.dart';
import '../../blocs/root/root_bloc.dart';
import '../../blocs/root/root_event.dart';
import '../../constants/constants.dart';
import '../../oauth2/oauth2_token.dart';
import '../../oauth2/oauth2_webview.dart';
import '../../routes.dart';
import '../../services/connectivity_service.dart';
import '../../utils/alert_util.dart';
import '../../utils/logger_util.dart';
import '../../widgets/no_data_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthScreenBloc _bloc;
  late final RootBloc _rootBloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AuthScreenBloc>(context);
    _rootBloc = BlocProvider.of<RootBloc>(context);
    _bloc.add(AuthScreenCheckInternet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      // appBar: _buildAppBar(),
      body: SafeArea(
        child: _buildBloc(),
      )
    );


  }

  Widget _buildBloc() {
    return BlocConsumer<AuthScreenBloc, AuthScreenState>(
      listener: (ctx, state) {
        if (state is AuthScreenGetUserProfileSuccess) {
          _rootBloc.add(GetUserProfileSuccessEvent(userProfile: state.userProfile));
        }
      },
      buildWhen: (state, nextState) {
        if (nextState is AuthScreenGetUserProfileSuccess || nextState is AuthScreenStateCheckInternet) {
          return false;
        }
        return true;
      },
      builder:(ctx, state) {
        final bool isLoading = (state is AuthScreenLoadingState && state.isLoading);
        return LoadingIndicator(
          isLoading: isLoading ,
          child: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(AuthScreenState state) {
    LoggerUtil.info('_buildBody state : $state');
    if(state is AuthScreenStateNoInternet) {
      return Center(
        child: NoInternetWidget(
          onPressedRetry: (){
            LoggerUtil.info('retry');
            _bloc.add(AuthScreenCheckInternet());
          },
        ),
      );
    }
    return Oauth2Webview(
      onLoginResult: (Oauth2Token? token, String? message) {
        LoggerUtil.info(
            'onLoginResult token: $token - message: $message');
        if (token != null && token.accessToken.isNotEmpty) {
          _bloc.add(AuthScreenLoggedIn(token: token));
        } else {
          if (message?.isNotEmpty ?? false) {
            showSnackBarError(context: context, message: message!);
          }
        }
        LoggerUtil.info('_showLoginPopup onLoginResult hide popup');
      },
      onTapTermsOfService: () {
        LoggerUtil.info('onTapTermsOfService');
        Navigator.pushNamed(context, Routes.articleScreen, arguments: {
          ArticleScreenArgs.articleType: ArticleType.termAndService
        });
      },
      isRegistrations: false,
    );
  }

  // PreferredSizeWidget _buildAppBar() {
  //   return S2EAppBar(
  //     backgroundColor: ColorUtil.primary,
  //     title: _bloc.articleType.title,
  //   );
  // }
}
