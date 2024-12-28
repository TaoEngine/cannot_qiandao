import 'package:cannot_qiandao/widgets/qiandaocard.dart';
import 'package:flutter/material.dart';

class QiandaoPage extends StatefulWidget {
  const QiandaoPage({super.key});

  @override
  State<QiandaoPage> createState() => _QiandaoPageState();
}

class _QiandaoPageState extends State<QiandaoPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        QiandaoCard(
          userid: "22909XXXX",
          username: "汪涛",
          qiandaoState: QiandaoState.notQiandao,
        ),
      ],
    );
  }
}
