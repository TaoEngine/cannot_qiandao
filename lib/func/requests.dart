import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mmkv/mmkv.dart';
import 'package:toml/toml.dart  ';
import 'dart:convert';

class Requests {
  /// POST请求
  /// - urlstr 网址
  /// - head 请求头
  /// - body 请求内容
  Future postData(String urlstr, Map<String, String> head, Object body) async {
    var url = Uri.parse(urlstr);
    var response = await http.post(url, headers: head, body: body);
    return json.decode(response.body);
  }

  /// GET请求
  /// - urlstr 网址
  /// - head 请求头
  Future getData(String urlstr, Map<String, String> head) async {
    var url = Uri.parse(urlstr);
    var response = await http.get(url, headers: head);
    return json.decode(response.body);
  }
}

class HttpUtil {
  /// 存放配置的数据库
  final MMKV _configDB = MMKV("configDB");

  /// 存放登录信息的数据库
  final MMKV _loginDB = MMKV("loginDB");
}

class QiandaoPlugin {
  /// 存放配置的数据库
  final MMKV _configDB = MMKV("configDB");

  /// 存放登录信息的数据库
  final MMKV _loginDB = MMKV("loginDB");

  loadToken({required String loadName}) async {
    final String loadURL = _configDB.decodeString("${loadName}URL") ?? "";
    final String loadMethod =
        _configDB.decodeString("${loadName}Method") ?? "GET";
    final Map loadHead =
        json.decode(_configDB.decodeString("${loadName}Head") ?? "");
    final Map loadBody =
        json.decode(_configDB.decodeString("${loadName}Body") ?? "");
    final Map loadExpect =
        json.decode(_configDB.decodeString("${loadName}Except") ?? "");

    final Map<String, String> loadHeadFormat =
        loadHead.map((key, value) => MapEntry(key, value as String));
    final Map<String, String> loadBodyFormat =
        loadBody.map((key, value) => MapEntry(key, value as String));
    final Requests tokenRequests = Requests();
    Map requestMap = loadMethod == "GET"
        ? await tokenRequests.getData(loadURL, loadHeadFormat)
        : await tokenRequests.postData(loadURL, loadHeadFormat, loadBodyFormat);

    for (var requestOne in requestMap.keys) {
      if (requestOne == loadExpect["token"]) {
        _loginDB.encodeString(
          "Token",
          requestMap[requestOne],
        );
      } else if (requestOne == loadExpect["username"]) {
        _loginDB.encodeString(
          "UserName",
          requestMap[requestOne],
        );
      } else if (requestOne == loadExpect["success"]) {
        _loginDB.encodeBool(
          "RunSuccess",
          requestMap[requestOne],
        );
      } else if (requestOne == loadExpect["state"]) {
        _loginDB.encodeString(
          "UserState",
          requestMap[requestOne],
        );
      } else if (requestOne == loadExpect["fence_latitude"]) {
        _loginDB.encodeString(
          "FenceLatitude",
          requestMap[requestOne],
        );
      } else if (requestOne == loadExpect["fence_longitude"]) {
        _loginDB.encodeString(
          "FenceLongitude",
          requestMap[requestOne],
        );
      } else if (requestOne == "error") {
        throw Exception("登录失败,学号密码不一致或者token失效");
      }
    }
  }

  /// 将TOML插件进行反序列化，
  /// 提取里面的签到请求信息，
  /// 并存到数据库中准备调用
  ///
  /// 这样假如考勤系统发生更改，
  /// 也能接受推送，
  /// 不用担心签不上到了
  loadPlugin() async {
    final String? pluginsURL = _configDB.decodeString("SourceURL");
    if (pluginsURL == null) throw Exception("插件网址不得为空");

    late final http.Response pluginsResponse;

    try {
      pluginsResponse = await http.get(Uri.parse(pluginsURL));
    } catch (e) {
      throw Exception("插件网址连接过于缓慢,稍后再试试看");
    }

    if (pluginsResponse.statusCode != 200) {
      throw Exception("连接不上插件网站,稍后再试试看");
    }

    final pluginsResponseUTF8 = utf8.decode(pluginsResponse.bodyBytes);
    final Map<String, dynamic> decodedData;

    try {
      decodedData = TomlDocument.parse(pluginsResponseUTF8).toMap();
    } catch (_) {
      throw Exception("解析插件数据失败");
    }

    for (var entry in decodedData.entries) {
      if (["GetToken", "State", "Fence", "QianDao"].contains(entry.key)) {
        try {
          _store(entry);
        } catch (_) {
          throw Exception("插件文件非标准形式,找流221汪涛教你编写符合标准的配置文件");
        }
      }
    }
  }

  void _store(MapEntry entry) {
    final String userid = _loginDB.decodeString("UserID") ?? "";
    final String password = _loginDB.decodeString("PasswordMD5") ?? "";
    final String token = _loginDB.decodeString("Token") ?? "";

    // 创建一个新的entry值，以便修改
    var updatedEntryValue = {};

    for (var queryValue in entry.value.entries) {
      if (queryValue.value is String) {
        // 替换字符串中的{{}}内容
        updatedEntryValue[queryValue.key] = queryValue.value
            .replaceAll("{{userid}}", userid)
            .replaceAll("{{password}}", password)
            .replaceAll("{{token}}", token);
      } else if (queryValue.value is Map) {
        // 替换Map中的值
        var updatedMapValue = {};
        for (var queryValueEntry in queryValue.value.entries) {
          updatedMapValue[queryValueEntry.key] = queryValueEntry.value
              .replaceAll("{{userid}}", userid)
              .replaceAll("{{password}}", password)
              .replaceAll("{{token}}", token);
        }
        updatedEntryValue[queryValue.key] = updatedMapValue;
      }
    }

    // 使用更新后的值进行存储
    _configDB.encodeString(
      "${entry.key}URL",
      updatedEntryValue["url"],
    );
    _configDB.encodeString(
      "${entry.key}Method",
      updatedEntryValue["method"],
    );
    _configDB.encodeString(
      "${entry.key}Head",
      json.encode(updatedEntryValue["head"]),
    );
    _configDB.encodeString(
      "${entry.key}Body",
      json.encode(updatedEntryValue["body"]),
    );
    _configDB.encodeString(
      "${entry.key}Query",
      json.encode(updatedEntryValue["query"]),
    );
    _configDB.encodeString(
      "${entry.key}Except",
      json.encode(updatedEntryValue["expect"]),
    );
  }
}

/// 使用md5加密
/// - data 加密数据
String toMD5(String data) {
  Uint8List content = const Utf8Encoder().convert(data);
  Digest digest = md5.convert(content);
  return digest.toString();
}
