import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/data/models/internal_web_view.dart';
import 'package:sing_app/widgets/no_data_widget.dart';
import 'package:sing_app/widgets/ss_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  final InternalWebViewModel? webViewModel;

  const WebViewWidget({Key? key, required this.webViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SSAppBar(
        title: webViewModel?.title ?? '',
        isBackNavigation: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    bool hasUrl = webViewModel?.url?.isNotEmpty ?? false;
    bool hasStringHtml = webViewModel?.stringHtml?.isNotEmpty ?? false;
    if (hasUrl) {
      return _buildWebViewWithUrl();
    } else if (hasStringHtml) {
      return _buildWebViewWithDataString();
    } else {
      return const NoDataWidget();
    }
  }

  Widget _buildWebViewWithUrl() {
    return WebView(
      initialUrl: webViewModel?.url,
      javascriptMode: JavascriptMode.unrestricted,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
        ),
      },
    );
  }

  Widget _buildWebViewWithDataString() {
    return WebView(
      initialUrl: Uri.dataFromString(
        webViewModel?.stringHtml ?? '',
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
        ),
      },
    );
  }
}
