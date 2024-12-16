import 'dart:convert';

import 'package:cannot_qiandao/func/requests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mmkv/mmkv.dart';
import 'package:permission_handler/permission_handler.dart';

class Qiandao {
  /// 存放配置的数据库
  final MMKV _configDB = MMKV("configDB");

  /// 存放登录的数据库
  final MMKV _loginDB = MMKV("loginDB");

  /// 加载插件
  final QiandaoPlugin _plugin = QiandaoPlugin();

  /// 处理Requests
  final Requests _requests = Requests();

  Future checkPermissions() async {
    var location = await Permission.locationWhenInUse.request();
    if (location.isDenied) {
      _configDB.encodeBool("Permission", false);
    }
    var locationalways = await Permission.locationAlways.request();
    if (locationalways.isDenied) {
      _configDB.encodeBool("Permission", false);
    }
    var battery = await Permission.ignoreBatteryOptimizations.request();
    if (battery.isDenied) {
      _configDB.encodeBool("Permission", false);
    }
    if (location.isGranted && locationalways.isGranted && battery.isGranted) {
      _configDB.encodeBool("Permission", true);
    } else {
      _configDB.encodeBool("Permission", false);
    }
  }

  Future init() async {
    try {
      await checkPermissions();
      await _plugin.loadToken(loadName: "GetToken");
    } catch (e) {
      return e;
    }

    final String token = _loginDB.decodeString("Token") ?? "";
    final String getTokenURL = _configDB.decodeString("GetTokenURL") ?? "";
    final String getTokenMethod =
        _configDB.decodeString("GetTokenMethod") ?? "GET";
    final Map getTokenHead =
        json.decode(_configDB.decodeString("GetTokenHead") ?? "");
    final Map getTokenBody =
        json.decode(_configDB.decodeString("GetTokenBody") ?? "");
    final Map getTokenExpect =
        json.decode(_configDB.decodeString("GetTokenExcept") ?? "");

    final Map<String, String> getTokenHeadFormat =
        getTokenHead.map((key, value) => MapEntry(key, value as String));
    final Map<String, String> getTokenBodyFormat =
        getTokenBody.map((key, value) => MapEntry(key, value as String));
    final Requests tokenRequests = Requests();
    Map requestMap = getTokenMethod == "GET"
        ? await tokenRequests.getData(getTokenURL, getTokenHeadFormat)
        : await tokenRequests.postData(
            getTokenURL, getTokenHeadFormat, getTokenBodyFormat);
  }
}
