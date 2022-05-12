import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/styles.dart';
import 'package:sing_app/widgets/buttons/gradient_button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import 'oauth2_config.dart';


class Oauth2Webview extends StatefulWidget {

  Function? onLoginResult;
  bool? isRegistrations;

  Oauth2Webview({
    Key? key,
    this.onLoginResult,
    this.isRegistrations,
  }) : super(key: key) ;

  @override
  _Oauth2WebviewState createState() => _Oauth2WebviewState();

}



class _Oauth2WebviewState extends State<Oauth2Webview> {

  String _url = '';
  bool _loading = true;

  @override
  void initState() {
    _url = _getUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoggerUtil.info('_Oauth2WebviewState: build');
    return Stack(
      children: [
        WebView(
          userAgent: "Mozilla/5.0 Google",
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (int progress) {
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) async {
            if(!mounted){
              LoggerUtil.error('not mounted');
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('${AppConfig.instance.values.authRedirectSchema}${Oauth2Config.redirectUri}')) {
              var uri = Uri.parse(request.url);
              // uri.queryParameters.forEach((k, v) {
              //   LoggerUtil.info('key: $k - value: $v');
              // });
              String? code = uri.queryParameters['code'];
              if(code != null) {
                _showDialogProgress();
                if(widget.isRegistrations ?? false) {
                  LoggerUtil.info('Registration code: $code');
                  _hideDialogProgress();
                  return NavigationDecision.navigate;
                  // await Oauth2Manager.instance.doAuthLogin(code, widget.onLoginResult, isRegistrations: true);
                } else {
                  LoggerUtil.info('Login code: $code');
                  await Oauth2Manager.instance.doAuthLogin(code, widget.onLoginResult);
                }
                _hideDialogProgress();
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            LoggerUtil.info('Page started loading: $url');
            _showDialogProgress();
          },
          onPageFinished: (String url) {
            LoggerUtil.info('Page finished loading: $url');
            _hideDialogProgress();
          },
          gestureNavigationEnabled: true,
        ),
        if(_loading)
          _loadingBox(),
      ],
    );
  }

  Widget _loadingBox(){
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          width: 300,
          height: 130,
          padding: const EdgeInsets.all(MyStyles.horizontalMargin),
          decoration: BoxDecoration(
            color: ColorUtil.blockBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpinKitRing(
                    color: Colors.white,
                    lineWidth: 2,
                    size: 32,
                  ),
                  const SizedBox(width: 10,),
                  Text(l("Loading, please wait..."),
                      style: const TextStyle(color: ColorUtil.white)
                  ),
                ],
              ),
              const SizedBox(height: MyStyles.horizontalMargin,),
              DefaultButton(
                text: l('Cancel'),
                height: 40,
                width: 150,
                onPressed: (){
                  widget.onLoginResult!(null, '');
                },
              )
            ],
          )
        ),
      ),
    );
  }

  String _getUrl() {
    if(widget.isRegistrations ?? false) {
      return Oauth2Manager.instance.getUrlRegistration();
    } else {
      return Oauth2Manager.instance.getUrlAuthorize();
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  _showDialogProgress() {
    setState(() {
      _loading = true;
    });
  }

  _hideDialogProgress() {
    setState(() {
      _loading = false;
    });
  }


}
