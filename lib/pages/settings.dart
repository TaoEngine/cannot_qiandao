import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:cannot_qiandao/widgets/dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("调下设置"),
      ),
      body: const SettingsView(),
    );
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text("去我的Github上狠狠的赞一个"),
          subtitle: const Text("TaoEngine出品，那必属精品啊!"),
          onTap: () => launchUrl(
            Uri.parse("https://github.com/TaoEngine/cannot_qiandao"),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 8,
            bottom: 8,
          ),
          child: Text(
            "插件设置",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: const Text("编辑签到插件URL"),
          subtitle: const Text("签到的核心就靠它了!"),
          onTap: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (builder) => const URLDialog(),
          ),
        ),
      ],
    );
  }
}
