import 'package:cannot_qiandao/widgets/dialog.dart';
import 'package:flutter/material.dart';

import 'package:cannot_qiandao/func/plugin.dart';
import 'package:cannot_qiandao/widgets/qiandaocard.dart';

part '../controller/qiandao.dart';

class QiandaoPage extends StatefulWidget {
  const QiandaoPage({super.key});

  @override
  State<QiandaoPage> createState() => _QiandaoPageState();
}

class _QiandaoPageState extends State<QiandaoPage> {
  bool showOneError = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: loadUserCards(),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 当Future还未完成时，显示加载中的UI
          return Container();
        } else if (snapshot.hasError) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (showOneError) {
                showOneError = false;
                showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                    errorcontent: snapshot.error.toString(),
                    onexit: () {
                      showOneError = true;
                    },
                  ),
                );
              }
            },
          );
          return const Center(
            child: Text("出现错误了!"),
          );
        } else {
          final List<Widget>? usercard = snapshot.data;
          if (usercard != null) {
            return ListView(
              children: usercard,
            );
          } else {
            return const Center(
              child: Text("空空如也"),
            );
          }
        }
      },
    );
  }
}
