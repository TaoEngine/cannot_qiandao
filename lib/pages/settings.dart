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

  /// 规则URL，用于同步签到规则
  String _sourceURL = "";

  /// 是否允许虚拟位置签到
  bool _switchVirtualQianDao = false;

  /// 给规则URL的dialog用的
  TextEditingController _fieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sourceURL = _configDB.decodeString("sourceURL") ?? "";
    _switchVirtualQianDao = _configDB.decodeBool("switchVirtualQianDao");
    _fieldController = TextEditingController(text: _sourceURL);
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
                path: 'TaoEngine',
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (builder) => _urldialog(),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ),
        SettingsCard(
          isImportant: false,
          leadingIcon: const Icon(Icons.login),
          thistitle: "输入登录信息",
          thissubtitle: "229094246汪涛已登录",
          trailingWidget: IconButton.outlined(
            onPressed: () {},
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
            onChanged: (value) {
              _switchVirtualQianDao = value;
              setState(() {
                _configDB.encodeBool(
                  "switchVirtualQianDao",
                  _switchVirtualQianDao,
                );
              });
            },
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

  Widget _urldialog() {
    return AlertDialog(
      icon: const Icon(Icons.power),
      title: const Text('规则URL'),
      content: const Text(
          '规则就像插件，和软件主体是分开的，这样可以灵活应对签到系统突发的更改\n规则将在APP启动时更新一次\n规则由TOML编写，有感兴趣的友友们可以和我一起交流哦！'),
      actions: [
        TextField(
          controller: _fieldController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '输入存放规则的URL',
          ),
          onChanged: (value) {
            setState(() {
              _sourceURL = value;
              _configDB.encodeString("sourceURL", _sourceURL);
            });
          },
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _sourceURL.isEmpty ? null : () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    );
  }
}
