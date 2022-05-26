
import 'package:flutter/material.dart';
import 'package:sing_app/data/models/internal_web_view.dart';

import '../routes.dart';

class UrlUtil {
  static openWeb(BuildContext context, InternalWebViewModel webView) async {
    Navigator.pushNamed(
      context,
      Routes.WEB_VIEW,
      arguments: webView,
    );
  }
}
