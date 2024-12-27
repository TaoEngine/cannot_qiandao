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
          userid: "229094246",
          username: "汪涛",
          qiandaoState: QiandaoState.notQiandao,
        ),
      ],
    );
  }
}
