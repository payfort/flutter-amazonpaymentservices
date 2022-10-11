
import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'environment_type.dart';

class FlutterAmazonpaymentservices {
  static const MethodChannel _channel = MethodChannel('flutter_amazonpaymentservices');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> get getUDID async {
    final String? getUDID = await _channel.invokeMethod('getUDID');
    return getUDID;
  }

  static Future<LinkedHashMap<Object?, Object?>> normalPay(
      Map request,
      EnvironmentType environmentType, {
        bool isShowResponsePage = true,
      }) async {
    final LinkedHashMap<Object?, Object?> result =
    await _channel.invokeMethod("normalPay", {
      "isShowResponsePage": isShowResponsePage,
      "environmentType": describeEnum(environmentType),
      "requestParam": request,
    });
    return result;
  }

  static Future<LinkedHashMap<Object?, Object?>> validateApi(
      Map request,
      EnvironmentType environmentType,
      ) async {
    final LinkedHashMap<Object?, Object?> result = await _channel.invokeMethod(
        "validateApi", {
      "environmentType": describeEnum(environmentType),
      "requestParam": request
    });
    return result;
  }

}
