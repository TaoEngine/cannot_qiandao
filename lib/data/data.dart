import 'package:isar/isar.dart';
part 'data.g.dart';

@collection

/// 软件设置数据库
class ConfigDB {
  /// 仅有一个配置
  Id id = 0;

  /// 插件网址
  String? pluginURL;

  /// 是否允许虚拟签到
  bool? falseLocation;
}

@collection

/// 用户数据库
class UserDB {
  /// 可多人创建,但是现在先做单人版
  // Id id = Isar.autoIncrement;
  Id id = 0;

  /// 登录用户学号
  String? userid;

  /// 登录用户姓名
  String? username;

  /// 登录用户密码md5
  String? passwordmd5;
}
