import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cannot_qiandao/data/data.dart';
import 'package:cannot_qiandao/func/replacer.dart';
import 'package:cannot_qiandao/func/requests.dart';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toml/toml.dart';

/// ### 签到插件模块
/// 所有与签到有关的交互都在这里了,
/// 正所谓前后端分离嘛!
///
/// ### 如何使用
/// 在启动APP的时候引入这一行即可:
/// ```dart
/// QiandaoPlugin _plugin = QiandaoPlugin();
/// _plugin.init();
/// ```
/// 然后就能在整个应用中执行诸如
/// - 签到插件获取
/// ```dart
/// _plugin.seturl("https://...");
/// ```
/// - 学号登录
/// ```dart
/// _plugin.login(
///   // 学号
///   id:"22909XXXX",
///   // 密码
///   password:"Ahgydx@920",
/// );
/// ```
/// - 获取签到状态
/// ```dart
/// _plugin.getstate(); => true/false
/// ```
/// - 获取签到任务
/// ```dart
/// _plugin.gettask(); => {
///   // 签到中心的经度
///   latitude:XXX,
///   // 签到中心的纬度
///   longitude:XXX,
///   // 签到的范围
///   fence:300,
///   // 签到开始时间
///   timestart:Datetime(21:30),
///   // 签到结束时间
///   timestop:Datetime(23:30),
/// }
/// ```
/// - 执行签到
/// ```dart
/// _plugin.qiandao(); => true/false
/// ```
///
/// 这一揽子流程了
class QiandaoPlugin {
  static final QiandaoPlugin _qiandaoPlugin = QiandaoPlugin._internal();
  factory QiandaoPlugin() => _qiandaoPlugin;
  QiandaoPlugin._internal();

  /// ### 签到插件初始化
  ///
  /// 只有经过初始化了,
  /// 签到插件才可用,
  /// 那些签到功能才可用
  ///
  /// 注意这个函数是异步的,
  /// 须在APP启动的时候引用,
  /// 但是在调试的时候,
  /// 可以允许先设置配置再初始化
  Future init() async {
    await _initDataBase();
    await _initpluginMap();
  }

  /// 签到APP的配置数据库
  late final Isar _qiandaoDB;

  /// 配置数据库子项
  ///
  /// 数据库子项不仅要用来存数据库,
  /// 数据库的子项也将直接用于向外界提供和配置URL和位置
  late ConfigDB _storedConfigDB;

  /// 用户数据库子项
  ///
  /// 配置数据库的子项也将直接用于向外界提供和配置用户信息
  /// 而不仅仅用于存数据库
  late UserDB _storedUserDB;

  /// 登录了吗
  late bool _islogin;

  /// Http请求器
  HttpUtil responser = HttpUtil();

  // 默认配置
  static const String defaultPluginURL =
      "https://github.moeyy.xyz/https://raw.githubusercontent.com/TaoEngine/cannot_qiandao/main/plugin/kqxt.toml";
  static const bool defaultLocationSet = false;

  /// 加载配置数据库
  Future _initDataBase() async {
    // 初始化应用目录和数据库
    final appdir = await getApplicationDocumentsDirectory();
    _qiandaoDB = await Isar.open(
      [ConfigDBSchema, UserDBSchema],
      directory: appdir.path,
      inspector: true,
    );

    // 检查并初始化配置数据
    ConfigDB? checkstoredConfigDB = await _qiandaoDB.configDBs.get(0);
    if (checkstoredConfigDB == null) {
      _storedConfigDB = ConfigDB()
        ..pluginURL = defaultPluginURL
        ..falseLocation = defaultLocationSet;
      await _qiandaoDB.writeTxn(() async {
        await _qiandaoDB.configDBs.put(_storedConfigDB);
      });
    } else {
      _storedConfigDB = checkstoredConfigDB;
    }

    // 检查并初始化用户数据
    UserDB? checkstoredUserDB = await _qiandaoDB.userDBs.get(0);
    if (checkstoredUserDB == null) {
      _islogin = false;
      _storedUserDB = UserDB()
        ..userid = null
        ..passwordmd5 = null;
      await _qiandaoDB.writeTxn(() async {
        await _qiandaoDB.userDBs.put(_storedUserDB);
      });
    } else {
      _storedUserDB = checkstoredUserDB;
      _islogin =
          _storedUserDB.userid != null && _storedUserDB.passwordmd5 != null;
    }
  }

  /// 将插件转换为本地使用的Map形式
  late Map<String, dynamic> _pluginMap;

  /// 设定好的解析方法,用在签到上
  static List<String> pluginEntries = [
    "GetToken",
    "LoadState",
    "LoadTask",
    "QianDao",
  ];

  /// 初始化Map,
  /// 也就是将签到的插件转换为本地可用的Toml
  Future _initpluginMap() async {
    Uri getURL = Uri.parse(_storedConfigDB.pluginURL!);
    String rawTomlData =
        await responser.beginRequest(url: getURL, method: HttpMethod.methodGET);
    try {
      _pluginMap = TomlDocument.parse(rawTomlData).toMap();
    } catch (error) {
      if (error is TomlParserException) {
        throw Exception("插件解析失败,非标准Toml格式");
      }
    }
  }

  /// 设置url
  Future seturl({required String url}) async {
    final uri = Uri.parse(url);
    if (uri.isAbsolute) {
      // 测试回带数据是否可行
      await _initpluginMap();

      // 设置url
      _storedConfigDB.pluginURL = url;

      // 可以用,写进数据库
      await _qiandaoDB.writeTxn(() async {
        await _qiandaoDB.configDBs.put(_storedConfigDB);
      });
    } else {
      throw Exception("URL格式不对");
    }
  }

  Future _refreshplugin({String? token}) async {
    Map<String, dynamic> updatedEntryValue = {};
    for (var entry in _pluginMap.entries) {
      if (pluginEntries.contains(entry.key)) {
        Map oneEntryValue = await replacedata(
          entry: entry,
          needlocation: false,
          userid: _storedUserDB.userid,
          passwordmd5: _storedUserDB.passwordmd5,
          token: token,
        );
        updatedEntryValue.addAll({entry.key: oneEntryValue});
      }
    }
    _pluginMap = updatedEntryValue;
  }

  /// 登录
  Future login({
    required String userid,
    required String password,
  }) async {
    // 将密码转换为md5格式
    final Uint8List passwordBytes = const Utf8Encoder().convert(password);
    _storedUserDB.passwordmd5 = md5.convert(passwordBytes).toString();
    _storedUserDB.userid = userid;

    // 刷新一下pluginMap,这下登录信息就完备了
    await _refreshplugin();

    // 最后将用户信息存入数据库中
    await _qiandaoDB.writeTxn(() async {
      await _qiandaoDB.userDBs.put(_storedUserDB);
    });
  }

  // 获取token
  Future gettoken() async {
    Map response = await responser.beginRequestDecode(
      url: Uri.parse(_pluginMap[pluginEntries[0]]["url"]),
      method: HttpMethod.methodPOST,
      headers: _pluginMap[pluginEntries[0]]["head"],
      body: _pluginMap[pluginEntries[0]]["body"],
      query: _pluginMap[pluginEntries[0]]["query"],
      expect: _pluginMap[pluginEntries[0]]["expect"],
    );
    var token = response["token"];
    await _refreshplugin(token: token);
    return response;
  }

  // 获取签到状态
  Future getstate() async {
    Map response = await responser.beginRequestDecode(
      url: Uri.parse(_pluginMap[pluginEntries[1]]["url"]),
      method: HttpMethod.methodGET,
      headers: _pluginMap[pluginEntries[1]]["head"],
      body: _pluginMap[pluginEntries[1]]["body"],
      query: _pluginMap[pluginEntries[1]]["query"],
      expect: _pluginMap[pluginEntries[1]]["expect"],
    );
    return response;
  }

  // 获取签到状态
  Future gettask() async {
    Map response = await responser.beginRequestDecode(
      url: Uri.parse(_pluginMap[pluginEntries[2]]["url"]),
      method: HttpMethod.methodGET,
      headers: _pluginMap[pluginEntries[2]]["head"],
      body: _pluginMap[pluginEntries[2]]["body"],
      query: _pluginMap[pluginEntries[2]]["query"],
      expect: _pluginMap[pluginEntries[2]]["expect"],
    );
    return response;
  }

  // 执行签到
  Future qiandao() async {
    Map response = await responser.beginRequestDecode(
      url: Uri.parse(_pluginMap[pluginEntries[3]]["url"]),
      method: HttpMethod.methodPOST,
      headers: _pluginMap[pluginEntries[3]]["head"],
      body: jsonEncode(_pluginMap[pluginEntries[3]]["body"]),
      query: _pluginMap[pluginEntries[3]]["query"],
      expect: _pluginMap[pluginEntries[3]]["expect"],
    );
    return response;
  }
}
