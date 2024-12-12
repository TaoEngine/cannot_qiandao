import 'package:flutter/material.dart';

class QiandaoPage extends StatefulWidget {
  const QiandaoPage({super.key});

  @override
  State<QiandaoPage> createState() => _QiandaoPageState();
}

class _QiandaoPageState extends State<QiandaoPage> {
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
              const Icon(
                Icons.task_alt,
                size: 100,
              ),
              const SizedBox(height: 10),
              Text(
                "签到状态: 已签到",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                "学号: 229094246\n位置:签到范围内",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}
