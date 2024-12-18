import 'package:cannot_qiandao/func/plugin.dart';
import 'package:flutter/material.dart';

class QiandaoPage extends StatefulWidget {
  const QiandaoPage({super.key});

  @override
  State<QiandaoPage> createState() => _QiandaoPageState();
}

class _QiandaoPageState extends State<QiandaoPage> {
  /// 签到插件
  final Plugin plugin = Plugin();

  /// 是否签到
  bool _isQiandao = false;

  /// 学号
  String _id = "";

  @override
  void initState() {
    super.initState();
    _id = plugin.getuserid() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const FloatingActionButton.extended(
        onPressed: null,
        icon: Icon(Icons.cancel),
        label: Text('没必要签到...'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              _isQiandao ? Icons.task_alt : Icons.cancel_outlined,
              size: 100,
            ),
            const SizedBox(height: 10),
            Text(
              "签到状态: ${_isQiandao ? "已签到" : "未签到"}",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              "学号: $_id\n位置:签到范围内",
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
