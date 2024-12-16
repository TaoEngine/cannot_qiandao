import 'package:cannot_qiandao/func/qiandao.dart';
import 'package:flutter/material.dart';
import 'package:mmkv/mmkv.dart';

class QiandaoPage extends StatefulWidget {
  const QiandaoPage({super.key});

  @override
  State<QiandaoPage> createState() => _QiandaoPageState();
}

class _QiandaoPageState extends State<QiandaoPage> {
  /// 签到引擎
  final Qiandao _qiandao = Qiandao();

  /// 存放配置的数据库
  final MMKV _configDB = MMKV("configDB");

  /// 存放登录的数据库
  final MMKV _loginDB = MMKV("loginDB");

  /// 是否签到
  bool _isQiandao = false;

  /// 学号
  String _id = "";

  @override
  void initState() {
    super.initState();
    _isQiandao = _configDB.decodeBool("Qiandao");
    _id = _loginDB.decodeString("UserID") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _qiandao.init(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {}
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
      },
    );
  }
}
