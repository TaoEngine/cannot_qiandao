import 'dart:async';
import 'dart:io';

import 'package:cannot_qiandao/data/data.dart';
import 'package:cannot_qiandao/func/requests.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toml/toml.dart';
import 'dart:typed_data';
import 'dart:convert';

/// 插件的HTTP交互模板
class PluginInteract {
  /// 交互网址
  Uri url;

  /// 交互方法
  HttpMethod method;

  /// 交互请求头
  Map<String, String> head;

  /// 交互请求负载
  Map<String, String> body;

  /// 交互查询方法
  Map<String, String> query;

  /// 希望获取的信息
  Map<String, String> expect;

  PluginInteract({
    required this.url,
    required this.method,
    required this.head,
    required this.body,
    required this.query,
    required this.expect,
  });
}

/// 签到插件模块
class Plugin {
  /// 单例应用创建
  ///
  /// 由于签到插件贯通全APP的流程，
  /// 所以把它做成单例应用就能在全局共用一个签到插件的所有配置了
  static final Plugin _plugin = Plugin._internal();
  factory Plugin() {
    return _plugin;
  }

  ///单例应用启动时会自动执行的东西
  Plugin._internal();

  /// 重置并加载Plugin
  Future<void> init() async {
    /// 加载Isar数据库
    await _initIsar();

    /// 预先加载保存过的插件网址
    await _initPluginURL();

    /// 加载插件本体
    await _initPlugin();

    /// 加载用户信息
    await _initUserInfo();
  }

  /**
   * 数据库加载方法
   */
  /// Isar数据库
  late final Isar _isar;

  /// Isar数据库的加载
  Future<void> _initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ConfigDBSchema, UserDBSchema],
      directory: dir.path,
      inspector: true,
    );
  }

  /// 新应用没有配置数据库,加载数据库时直接填写默认信息
  Future<void> _loadDefaultConfigDB() async {
    // 默认网址
    const String defaultPluginURL =
        "https://github.moeyy.xyz/https://raw.githubusercontent.com/TaoEngine/cannot_qiandao/main/plugin/kqxt.toml";
    // 默认定位设置
    const bool defaultLocationSet = false;

    // 将默认配置创建到数据库中
    final ConfigDB defaultConfig = ConfigDB()
      ..pluginURL = defaultPluginURL
      ..falseLocation = defaultLocationSet;
    await _isar.writeTxn(() async {
      await _isar.configDBs.put(defaultConfig);
    });

    // 修改默认网址
    _pluginURL = Uri.parse(defaultPluginURL);
  }

  /**
   * 获取插件的网址等一系列方法
   */

  /// 插件的网址
  late Uri _pluginURL;

  /// 插件在初始化的时候自动获取之前保存过的URL
  Future<void> _initPluginURL() async {
    // 1.读取配置数据库
    var storedConfig = await _isar.configDBs.get(0);

    // 2.检测数据库是否为空，如果是空的就将默认的配置填上去
    if (storedConfig == null) {
      await _loadDefaultConfigDB();
    } else {
      _pluginURL = Uri.parse(storedConfig.pluginURL!);
    }
  }

  /// 获取插件URL，以String形式输出
  String getpluginURL() {
    return _pluginURL.toString();
  }

  /// 更换插件的URL
  Future<void> changePluginURL(String url) async {
    final Uri pluginNewURL = Uri.parse(url);

    /// 1.检测链接文本是否为空
    if (url.isNotEmpty) {
      // 2.检测链接是否标准
      if (pluginNewURL.isAbsolute) {
        // 3.鉴别链接末尾是不是.toml结尾
        if (url.endsWith(".toml")) {
          // 4.鉴别链接是否能够访问
          try {
            await _getRawPlugin(pluginNewURL);
          } catch (_) {
            rethrow;
          }
          // 5.鉴别完成,将实施新链接
          final ConfigDB defaultConfig = ConfigDB()..pluginURL = url;
          await _isar.writeTxn(() async {
            await _isar.configDBs.put(defaultConfig);
          });
          _pluginURL = pluginNewURL;
        } else {
          throw Exception("链接结尾并非是.toml为结尾的插件链接,请检查链接");
        }
      } else {
        throw Exception("链接格式有误,请检查链接");
      }
    } else {
      throw Exception("url不得为空");
    }
  }

  /**
   * 获取插件内容、解析插件等一系列方法
   */

  /// 设定好的解析方法,用在签到上
  static List<String> pluginEntries = [
    "GetToken",
    "LoadState",
    "LoadTask",
    "QianDao",
  ];

  /// 获取Token的交互方式
  late PluginInteract _getTokenInteract;

  /// 获取签到状态的交互方式
  late PluginInteract _loadStateInteract;

  /// 获取地理围栏的交互方式
  late PluginInteract _loadTaskInteract;

  /// 签到的交互方式
  late PluginInteract _qiandaoInteract;

  /// (重新)加载插件
  Future<void> _initPlugin() async {
    // 1.从网址获取Plugin原始数据
    String rawTomlData = await _getRawPlugin(null);
    // 2.解析Plugin,这样就能给签到系统使用了
    _parsePlugin(rawTomlData);
  }

  /// 从网上下载Toml原始格式插件
  Future<String> _getRawPlugin(Uri? url) async {
    Uri getURL = url ?? _pluginURL;

    // 1.获取网上的Toml插件
    try {
      final http.Response pluginsResponseRaw = await http.get(getURL);
      if (pluginsResponseRaw.statusCode != 200) {
        throw Exception("插件的服务器返回了一个${pluginsResponseRaw.statusCode}错误,请检查一下");
      } else {
        // 2.转换插件返回的Raw格式为可读格式,一般是utf-8
        return utf8.decode(pluginsResponseRaw.bodyBytes);
      }
    } catch (error) {
      if (error is SocketException) {
        throw Exception("连接不上插件网站,稍后再试试看");
      } else if (error is TimeoutException) {
        throw Exception("插件网址连接过于缓慢,稍后再试试看");
      } else if (error is HandshakeException) {
        throw Exception("插件网址的证书失效了,换个源吧");
      } else {
        rethrow;
      }
    }
  }

  /// 插件解析器,将Toml解析出来
  void _parsePlugin(String rawTomlData) {
    late final Map tomlMap;
    // 1.将Toml解析成Map格式
    try {
      tomlMap = TomlDocument.parse(rawTomlData).toMap();
    } catch (error) {
      if (error is TomlParserException) {
        throw Exception("插件解析失败,非标准Toml格式");
      }
    }

    // 2.通过解析方法解析出插件内符合的内容
    Map updatedEntryValue = {};
    try {
      for (var entry in tomlMap.entries) {
        if (pluginEntries.contains(entry.key)) {
          Map oneEntryValue = _replacePlugin(entry);
          updatedEntryValue.addAll({entry.key: oneEntryValue});
        }
      }
    } catch (error) {
      if (error is TypeError) {
        throw Exception("插件文件非标准形式,找流221汪涛教你编写符合标准的配置文件");
      } else {
        throw Exception("抱歉,解析插件时遭遇严重问题\n将此页面截图发给流221汪涛,多谢\n$error");
      }
    }

    // 3.将解析出来的插件赋值到其内置方法里
    try {
      _getTokenInteract = PluginInteract(
        url: Uri.parse(updatedEntryValue["GetToken"]["url"]),
        method: updatedEntryValue["GetToken"]["method"] == "POST"
            ? HttpMethod.methodPOST
            : HttpMethod.methodGET,
        head: updatedEntryValue["GetToken"]["head"],
        body: updatedEntryValue["GetToken"]["body"],
        query: updatedEntryValue["GetToken"]["query"],
        expect: updatedEntryValue["GetToken"]["expect"],
      );
      _loadStateInteract = PluginInteract(
        url: Uri.parse(updatedEntryValue["LoadState"]["url"]),
        method: updatedEntryValue["LoadState"]["method"] == "POST"
            ? HttpMethod.methodPOST
            : HttpMethod.methodGET,
        head: updatedEntryValue["LoadState"]["head"],
        body: updatedEntryValue["LoadState"]["body"],
        query: updatedEntryValue["LoadState"]["query"],
        expect: updatedEntryValue["LoadState"]["expect"],
      );
      _loadTaskInteract = PluginInteract(
        url: Uri.parse(updatedEntryValue["LoadTask"]["url"]),
        method: updatedEntryValue["LoadTask"]["method"] == "POST"
            ? HttpMethod.methodPOST
            : HttpMethod.methodGET,
        head: updatedEntryValue["LoadTask"]["head"],
        body: updatedEntryValue["LoadTask"]["body"],
        query: updatedEntryValue["LoadTask"]["query"],
        expect: updatedEntryValue["LoadTask"]["expect"],
      );
      _qiandaoInteract = PluginInteract(
        url: Uri.parse(updatedEntryValue["QianDao"]["url"]),
        method: updatedEntryValue["QianDao"]["method"] == "POST"
            ? HttpMethod.methodPOST
            : HttpMethod.methodGET,
        head: updatedEntryValue["QianDao"]["head"],
        body: updatedEntryValue["QianDao"]["body"],
        query: updatedEntryValue["QianDao"]["query"],
        expect: updatedEntryValue["QianDao"]["expect"],
      );
    } catch (error) {
      throw Exception("抱歉,解析插件时遭遇严重问题\n将此页面截图发给流221汪涛,多谢\n$error");
    }
  }

  /// 插件解析器,替换插件提供的{{}}内容
  Map<String, dynamic> _replacePlugin(MapEntry entry) {
    // 1.创建一个新的entry值，以便修改
    Map<String, dynamic> updatedEntryValue = {};

    // 2.开始替换
    for (var queryValue in entry.value.entries) {
      if (queryValue.value is String) {
        // 2.1.替换字符串中的{{}}内容
        updatedEntryValue[queryValue.key] = queryValue.value
            .replaceAll("{{userid}}", _userid ?? "null")
            .replaceAll("{{password}}", _passwordmd5 ?? "null")
            .replaceAll("{{token}}", _token ?? "null")
            .replaceAll("{{nowdate}}", "2024-12-18");
      } else if (queryValue.value is Map) {
        // 2.2.替换Map中的值
        Map<String, String> updatedMapValue = {};
        for (var queryValueEntry in queryValue.value.entries) {
          updatedMapValue[queryValueEntry.key] = queryValueEntry.value
              .replaceAll("{{userid}}", _userid ?? "null")
              .replaceAll("{{password}}", _passwordmd5 ?? "null")
              .replaceAll("{{token}}", _token ?? "null")
              .replaceAll("{{nowdate}}", "2024-12-18");
        }
        updatedEntryValue[queryValue.key] = updatedMapValue;
      }
    }

    return updatedEntryValue;
  }

  /**
   * 获取用户学号、密码和token等一系列方法
   */

  /// 登录用户学号
  String? _userid;

  /// 登录用户名
  String? _username;

  /// 登录用户密码md5
  String? _passwordmd5;

  /// 登录需要的token,注意每次初始化程序时均需更新token
  String? _token;

  /// 用户信息在初始化的时候自动获取之前保存过的信息
  Future<void> _initUserInfo() async {
    // 1.读取用户数据库
    var storedConfig = await _isar.userDBs.get(0);

    // 2.检测数据库是否为空
    if (storedConfig != null) {
      // 2.1.加载用户名密码
      _passwordmd5 = storedConfig.passwordmd5;
      _userid = storedConfig.userid;

      // 2.2.刷新一下plugin,使其含有用户名和密码
      await _initPlugin();

      // 2.3.加载用户名和Token
      await _loadNameToken();

      // 2.4.最后再刷新下plugin
      await _initPlugin();
    } else {
      throw Exception("请先登录");
    }
  }

  /// 更换用户信息
  Future<void> changeUserInfo(String userid, String password) async {
    // 1.将密码转换为md5格式
    final Uint8List passwordBytes = const Utf8Encoder().convert(password);
    _passwordmd5 = md5.convert(passwordBytes).toString();
    _userid = userid;

    // 2.刷新一下plugin,使其含有用户名和密码
    await _initPlugin();

    // 3.加载用户名和Token
    await _loadNameToken();

    // 4.最后再刷新下plugin
    await _initPlugin();

    // 5.万无一失时就可以把数据保存到数据库里了
    final UserDB newUserData = UserDB()
      ..userid = _userid
      ..passwordmd5 = _passwordmd5;
    await _isar.writeTxn(() async {
      await _isar.userDBs.put(newUserData);
    });
  }

  /// 获取Token和用户名
  Future<void> _loadNameToken() async {
    /// 获取Token的URL
    Uri getTokenURL = _getTokenInteract.url;

    /// 获取签到状态的方法
    HttpMethod getTokenMethod = _getTokenInteract.method;

    /// 获取Token的请求头
    Map<String, String> getTokenHead = _getTokenInteract.head;

    /// 获取Token的负载
    Map<String, String> getTokenBody = _getTokenInteract.body;

    /// 获取Token的期望
    Map<String, String> getTokenExpect = _getTokenInteract.expect;

    /// HTTP请求器
    HttpUtil responser = HttpUtil();

    /// 获取token和用户名
    Map response = await responser.beginRequestDecode(
      getTokenURL,
      getTokenMethod,
      getTokenHead,
      getTokenBody,
      null,
      getTokenExpect,
    );

    _token = response["token"];
    _username = response["username"];
  }

  /// 获取签到状态
  Future<Map> getState() async {
    /// 获取签到状态的URL
    Uri loadStateURL = _loadStateInteract.url;

    /// 获取签到状态的方法
    HttpMethod loadloadStateMethod = _loadStateInteract.method;

    /// 获取签到状态的请求头
    var loadStateHead = _loadStateInteract.head;

    /// 获取签到状态的负载
    var loadStateQuery = _loadStateInteract.query;

    /// 获取签到状态的期望
    var loadStateExpect = _loadStateInteract.expect;

    /// HTTP请求器
    HttpUtil responser = HttpUtil();

    /// 获取token和用户名
    Map response = await responser.beginRequestDecode(
      loadStateURL,
      loadloadStateMethod,
      loadStateHead,
      null,
      loadStateQuery,
      loadStateExpect,
    );

    return response;
  }

  /// 获取用户学号
  String? getuserid() {
    return _userid;
  }

  /// 获取用户名
  String? getusername() {
    return _username;
  }

  /// 获取token
  String? gettoken() {
    return _token;
  }
}
