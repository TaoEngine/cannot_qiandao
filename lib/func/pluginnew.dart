import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cannot_qiandao/data/data.dart';
import 'package:http/http.dart' as http;
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
  /// 单例应用创建
  ///
  /// 由于签到插件贯通全APP的流程，
  /// 所以把它做成单例应用就能在全局共用一个签到插件的所有配置了
  static final QiandaoPlugin _qiandaoPlugin = QiandaoPlugin._internal();
  factory QiandaoPlugin() {
    return _qiandaoPlugin;
  }
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
  ///
  /// 这一流程包括
  /// - 加载配置数据库\
  /// 这个数据库存放了
  ///   - 用户登录的学号和密码(转过md5的)
  ///   - 之前导入的配置URL
  ///   - 是否允许虚拟签到的配置
  ///
  /// - 从数据库预先加载保存过的插件网址\
  /// 如果这个应用是新的,
  /// 那么应用会设置默认的签到插件网址为:
  /// https://raw.githubusercontent.com/TaoEngine/cannot_qiandao/main/plugin/kqxt.toml
  ///
  /// - 从插件网址获取预设签到API\
  /// 签到API包括
  ///   - 获取签到操作所需的用户凭证Token
  ///   - 获取今日签到的状态,是签到了还是没签到
  ///   - 获取学校的签到任务,如签到时间,签到位置
  ///   - 执行签到
  ///
  /// - 从数据库预先加载用户信息\
  /// 如果这个应用是新的,
  /// 那么用户配置将都为null\
  /// 此时这些功能将全部失效,执行时会报错
  ///   - 获取签到状态
  ///   - 获取签到任务
  ///   - 执行签到
  ///
  Future init() async {
    await _initDataBase();
    await _initpluginURL();
    await _initpluginMap();
    await _initUserInfo();
  }

  /**
   * 加载配置数据库
   * 
   * 在数据库的选择上,
   * 我选择了可以跨平台的Isar数据库,
   * 一是我最擅长的就是这个轻量化数据库的开发了
   * 二是这个APP就能在安卓/苹果/Windows/Mac共同运行了
   */

  /// 签到APP的配置数据库
  late final Isar _qiandaoDB;

  /// 配置数据库子项
  late ConfigDB storedconfigDB;

  /// 用户数据库子项
  late UserDB storeduserDB;

  /// 加载配置数据库
  Future _initDataBase() async {
    /**
     * 加载数据库
     * 
     * 两个数据库都要被加载
     * 一个是ConfigDBSchema配置数据库
     * 另一个是UserDBSchema用户数据库
     */
    final appdir = await getApplicationDocumentsDirectory();
    _qiandaoDB = await Isar.open(
      [ConfigDBSchema, UserDBSchema],
      directory: appdir.path,
      inspector: true,
    );

    /**
     * 检查数据库是不是新的
     * 
     * 一般情况下这款APP要是刚被安装好后就打开,
     * 那么数据库就是空的,
     * 这样会导致一些功能失效并出现错误.
     * 所以要先给一些重点功能设上值,
     */
    // 默认插件网址
    const String defaultPluginURL =
        "https://github.moeyy.xyz/https://raw.githubusercontent.com/TaoEngine/cannot_qiandao/main/plugin/kqxt.toml";
    // 默认定位配置
    const bool defaultLocationSet = false;

    // 判断数据库是否为空
    ConfigDB? checkstoredconfigDB = await _qiandaoDB.configDBs.get(0);
    UserDB? checkstoreduserDB = await _qiandaoDB.userDBs.get(0);
    if (checkstoredconfigDB == null) {
      // 覆写默认数据库配置
      storedconfigDB = ConfigDB()
        ..pluginURL = defaultPluginURL
        ..falseLocation = defaultLocationSet;
      await _qiandaoDB.writeTxn(() async {
        await _qiandaoDB.configDBs.put(storedconfigDB);
      });
    } else {
      // 转储到方法中
      storedconfigDB = checkstoredconfigDB;
    }
    if (checkstoreduserDB == null) {
      _emptyuser = true;
    } else {
      _emptyuser = false;
      // 转储到方法中
      storeduserDB = checkstoreduserDB;
    }
  }

  /**
   * 从数据库预先加载保存过的插件网址
   * 
   * 在我做这个APP的时候其实也有很多人也在做我所在的学校的签到APP,
   * 但是在11月和12月期间,
   * 学校为了打击这类自动化签到插件,
   * 把学校的签到逻辑改掉了,
   * (虽然我的APP肯定不属于这一类哈)
   * 
   * 这时候我才了解到,
   * 如果APP不灵活,
   * 迟早会被学校发现并判定失效,
   * 本人也会被学校通报批评的.
   * 于是我将签到的这个过程从我的APP中剥离出来,
   * 制作成了插件,
   * 这样学校改逻辑的时候也方便
   */

  /// 插件的网址
  late Uri _pluginURL;

  Future _initpluginURL() async {
    /**
     * 读取配置数据库
     * 
     * 因为数据库的非空检查已经在数据库初始化之前就做完了
     * 因此这里读取数据库就不用担心数据库存在空值了
     */
    _pluginURL = Uri.parse(storedconfigDB.pluginURL!);
  }

  /**
   * 从插件网址获取预设签到API
   * 
   * 签到API,
   * 就是
   */
  ///
  late Map<String, dynamic> _pluginMap;

  ///
  Future _initpluginMap() async {
    String rawTomlData = await _getRawPlugin(null);
    try {
      _pluginMap = TomlDocument.parse(rawTomlData).toMap();
    } catch (error) {
      if (error is TomlParserException) {
        throw Exception("插件解析失败,非标准Toml格式");
      }
    }
  }

  /// 从网上下载Toml原始格式插件
  Future<String> _getRawPlugin(Uri? url) async {
    Uri getURL = url ?? _pluginURL;
    try {
      final http.Response pluginsResponseRaw = await http.get(getURL);
      if (pluginsResponseRaw.statusCode != 200) {
        throw Exception("插件的服务器返回了一个${pluginsResponseRaw.statusCode}错误,请检查一下");
      } else {
        // 转换插件返回的Raw格式为可读格式,一般是utf-8
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

  /**
   * 从数据库预先加载用户信息
   */
  /// 没有用户信息,
  /// 值为true,
  /// 有的话就为false,
  ///
  /// 这种情况下需要登录,
  /// 否则
  ///
  /// - 获取签到状态
  /// - 获取签到任务
  /// - 执行签到
  ///
  /// 将全部失效
  late bool _emptyuser;

  /// 用户学号
  late String userid;

  /// 用户名
  late String username;

  /// 用户密码(md5)
  late String _passwordmd5;

  /// 登录需要的token,
  /// 注意每次初始化插件时均需更新token
  late String _token;

  /// 加载用户信息
  Future _initUserInfo() async {
    if (_emptyuser) {
      throw IsarError("请先登录!");
    }
  }

  /// 登录
  Future login({
    required String id,
    required String password,
  }) async {}
}
