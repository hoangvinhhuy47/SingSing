import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/profile/profile_screen_bloc.dart';
import 'package:sing_app/blocs/profile/profile_screen_event.dart';
import 'package:sing_app/blocs/root/root_bloc.dart';
import 'package:sing_app/blocs/root/root_event.dart';
import 'package:sing_app/blocs/root/root_state.dart';
import 'package:sing_app/blocs/tabbar/tabbar_bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_event.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/oauth2/oauth2_popup.dart';
import 'package:sing_app/oauth2/oauth2_token.dart';
import 'package:sing_app/screens/intro_screen.dart';
import 'package:sing_app/screens/tabbar_screen.dart';
import 'package:sing_app/utils/alert_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/styles.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late RootBloc _rootBloc;
  late TabBarBloc _tabBarBloc;

  @override
  void initState() {
    _rootBloc = BlocProvider.of<RootBloc>(context);
    _tabBarBloc = BlocProvider.of<TabBarBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _rootBloc.close();
    _tabBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: BlocListener<RootBloc, RootState>(
          listener: (ctx, state) {
            if(state is LoggedInSuccess) {
              BlocProvider.of<WalletScreenBloc>(context).add(
                const WalletScreenShowLoadingEvent(isLoading: true),
              );
              BlocProvider.of<ProfileScreenBloc>(context).add(
                const ProfileScreenShowLoadingEvent(isLoading: true),
              );
            }

            if (state is GetUserProfileSuccess || state is LoggedOutSuccess) {
              BlocProvider.of<WalletScreenBloc>(context).add(
                const WalletScreenEventStarted(isRefreshing: true),
              );
              BlocProvider.of<ProfileScreenBloc>(context).add(
                const ProfileScreenEventStarted(isRefreshing: true),
              );
            }

            if (state is ShowLoginPopup) {
              BlocProvider.of<WalletScreenBloc>(context).add(
                const WalletScreenShowLoadingEvent(isLoading: true),
              );
              BlocProvider.of<ProfileScreenBloc>(context).add(
                const ProfileScreenShowLoadingEvent(isLoading: true),
              );
              _showLoginPopup();
            }

            if(state is HideOath2Popup){
              BlocProvider.of<WalletScreenBloc>(context).add(
                const WalletScreenShowLoadingEvent(isLoading: false),
              );
              BlocProvider.of<ProfileScreenBloc>(context).add(
                const ProfileScreenShowLoadingEvent(isLoading: false),
              );
            }

            if (state is ShowRegistrationsPopup) {
              _showRegistrationsPopup();
            }

            if (state is ShowAccessTokenExpiredAlert) {
              _showAccessTokenExpiredAlert();
            }
          },
          child: BlocBuilder<RootBloc, RootState>(
            buildWhen: (preState, nextState) {
              if (nextState is LoggedOutSuccess) {
                return false;
              }
              if (nextState is LoggedInSuccess || nextState is GetUserProfileSuccess) {
                return false;
              }
              if (nextState is ShowAccessTokenExpiredAlert) {
                return false;
              }
              if (nextState is ShowLoginPopup || nextState is ShowRegistrationsPopup) {
                return false;
              }
              if (nextState is HideOath2Popup) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if(state is OpenIntroScreen){
                return const IntroScreen();
              } else  if (state is Authenticated || state is Unauthenticated) {
                return const TabBarScreen();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Future _showLoginPopup() async {
    Navigator.popUntil(context, (route) => route.isFirst);
    Oauth2Dialog(
        context: context,
        onLoginResult: (Oauth2Token? token, String? message) {
          LoggerUtil.info('_showLoginPopup onLoginResult token: $token - message: $message');
          if (token != null && token.accessToken.isNotEmpty) {
            _rootBloc.add(LoggedIn(token: token));
          } else {
            _rootBloc.add(HideLoginPopupEvent());
            if(message?.isNotEmpty ?? false) {
              showSnackBarError(context: context, message: message!);
            }
          }
          LoggerUtil.info('_showLoginPopup onLoginResult hide popup');
          Navigator.of(context).pop();
        }).show();
  }

  Future _showRegistrationsPopup() async {
    Navigator.popUntil(context, (route) => route.isFirst);
    Oauth2Dialog(
        context: context,
        isRegistrations: true,
        onLoginResult: (Oauth2Token? token, String? message) {
          LoggerUtil.info('_showRegistrationsPopup onLoginResult token: $token - message: $message');
          if (token != null && token.accessToken.isNotEmpty) {
            _rootBloc.add(LoggedIn(token: token));
          } else {
            _rootBloc.add(HideLoginPopupEvent());
            if(message?.isNotEmpty ?? false) {
              showSnackBarError(context: context, message: message!);
            }
          }
          LoggerUtil.info('_showRegistrationsPopup onLoginResult hide popup');
          Navigator.of(context).pop();
        }).show();
  }

  Future _showAccessTokenExpiredAlert() async {
    Navigator.popUntil(context, (route) => route.isFirst);
    final bool isDismiss = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: SizedBox(
            width: 200,
            height: 100,
            child: Column(
              children: [
                Text(l('Session expired. Please login again.')),
                const SizedBox(height: MyStyles.horizontalMargin,),
                TextButton(onPressed: (){
                  Navigator.pop(context, true);
                }, child: Text(l('Ok')))
              ],
            ),
          ),
        ));
    if (isDismiss) {
      _rootBloc.add(DismissAccessTokenExpiredAlert());
    }
  }

}
