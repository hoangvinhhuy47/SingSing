import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';

final List<String> _productLists = [
  'com.mic.id-gold',
  'com.mic.id-bronze',
  'com.mic.id-silver'
];

void requestPurchase(String tier) async {
  if (Platform.isIOS) {
    await FlutterInappPurchase.instance.initConnection;
    getItems(tier);
  } else {
    Fluttertoast.showToast(msg: 'Payment only Appstore');
  }
}

void getItems(String tier) async {
  await FlutterInappPurchase.instance.getProducts(_productLists);

  buyItem(tier);
}

void buyItem(String tier) async {
  try {
    if (tier == 'Silver') {
      await FlutterInappPurchase.instance.requestPurchase('com.mic.id-silver');
    }
    if (tier == 'Gold') {
      await FlutterInappPurchase.instance.requestPurchase('com.mic.id-gold');
    }
    if (tier == 'Bronze') {
      await FlutterInappPurchase.instance.requestPurchase('com.mic.id-bronze');
    }
  } catch (error) {
    Fluttertoast.showToast(msg: error.toString());
  }
}
