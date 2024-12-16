import 'package:cannot_qiandao/widgets/dialog.dart';
import 'package:flutter/material.dart';

import 'package:cannot_qiandao/widgets/settingscard.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:mmkv/mmkv.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// 存放配置的数据库
  final MMKV _configDB = MMKV("configDB");

  /// 存放登录的数据库
  final MMKV _loginDB = MMKV("loginDB");

  /// 规则URL，用于同步签到规则
  String _sourceURL = "";

  /// 登录的姓名
  String? _userName;

  /// 登录的ID
  String? _id;

  /// 是否允许虚拟位置签到
  bool _switchVirtualQianDao = false;

  @override
  void initState() {
    super.initState();
    _configDB.decodeString("SourceURL") ??
        _configDB.encodeString(
          "SourceURL",
          "https://raw.githubusercontent.com/TaoEngine/cannot_qiandao/main/plugin/kqxt.toml",
        );
    _sourceURL = _configDB.decodeString("SourceURL")!;
    _userName = _loginDB.decodeString("UserName");
    _id = _loginDB.decodeString("UserID");
    _switchVirtualQianDao = _configDB.decodeBool("SwitchVirtualQianDao");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SettingsCard(
          isImportant: true,
          leadingIcon: const Icon(Icons.star),
          thistitle: "去我的Github上狠狠的赞一个",
          thissubtitle: "流221汪涛出品，必属精品",
          trailingWidget: IconButton.outlined(
            onPressed: () {
              launchUrl(Uri(
                scheme: 'https',
                host: 'github.com',
                path: 'TaoEngine/cannot_qiandao',
              ));
            },
            icon: const Icon(Icons.arrow_forward),
          ),
        ),
        SettingsCard(
          isImportant: false,
          leadingIcon: const Icon(Icons.power),
          thistitle: "填入签到规则URL",
          thissubtitle: "当前为$_sourceURL",
          trailingWidget: IconButton.outlined(
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (builder) => URLDialog(
                onEditFunction: () => setState(() {
                  _sourceURL = _configDB.decodeString("SourceURL")!;
                }),
              ),
            ),
            icon: const Icon(Icons.edit),
          ),
        ),
        SettingsCard(
          isImportant: false,
          leadingIcon: const Icon(Icons.login),
          thistitle: "输入登录信息",
          thissubtitle: _id != null && _userName != null
              ? "$_id($_userName) 已登录"
              : "请先登录",
          trailingWidget: IconButton.outlined(
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (builder) => UserDialog(
                onEditFunction: () => setState(() {
                  _userName = _loginDB.decodeString("UserName");
                  _id = _loginDB.decodeString("UserID");
                }),
                onSaveFunction: () => setState(() {
                  _userName = _loginDB.decodeString("UserName");
                  _id = _loginDB.decodeString("UserID");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$_userName,欢迎回来!"),
                      behavior: SnackBarBehavior.floating));
                }),
                onErrorFunction: (error) => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("出错了"),
                    content: Text(error.toString().split(":").last),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("返回"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            icon: const Icon(Icons.edit),
          ),
        ),
        SettingsCard(
          isImportant: false,
          leadingIcon: const Icon(Icons.gps_fixed),
          thistitle: "忽略位置信息直接签到",
          thissubtitle: "仅为本人学习研究",
          trailingWidget: Switch(
            value: _switchVirtualQianDao,
            // onChanged: (value) {
            //   _switchVirtualQianDao = value;
            //   setState(() {
            //     _configDB.encodeBool(
            //       "switchVirtualQianDao",
            //       _switchVirtualQianDao,
            //     );
            //   });
            // },
            onChanged: null,
          ),
        ),
        SettingsCard(
          isImportant: false,
          leadingIcon: const Icon(Icons.description),
          thistitle: "关于此应用",
          thissubtitle: "查看有关许可",
          trailingWidget: IconButton.outlined(
            onPressed: () => showLicensePage(
              context: context,
              applicationVersion: "0.0.3",
              applicationLegalese:
                  "流221汪涛强势出品\n软件包括本人编写的规则基于LGPL协议分发\n可以共同研究，但不许独吞我的成果！\n严禁商用！",
            ),
            icon: const Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }
}
