import 'package:flutter/material.dart';

/// 签到状态
///
/// - `notneedQiandao`表示早于签到范围内,现在没必要签到
/// - `needQiandao`表示在签到时间范围内,现在赶紧签到
/// - `cannotQiandao`表示已经签到过了,不管是否在签到时间范围内
/// - `notQiandao`表示已经过了签到时间范围内了,关键还未签到
enum QiandaoState {
  /// 早于签到范围内,现在没必要签到
  notneedQiandao,

  /// 在签到时间范围内,现在赶紧签到
  needQiandao,

  /// 已经签到过了
  cannotQiandao,

  /// 已经过了签到时间范围内了,关键还未签到
  notQiandao,
}

class QiandaoCard extends StatelessWidget {
  // 用户学号
  final String userid;

  // 用户姓名
  final String username;

  // 显示签到状态用的
  final QiandaoState qiandaoState;

  const QiandaoCard({
    super.key,
    required this.userid,
    required this.username,
    required this.qiandaoState,
  });

  @override
  Widget build(BuildContext context) {
    final String infotitle;
    switch (qiandaoState) {
      case QiandaoState.notneedQiandao:
        infotitle = "还没到签到时间呢!";
        break;
      case QiandaoState.needQiandao:
        infotitle = "赶紧去签到了!";
        break;
      case QiandaoState.cannotQiandao:
        infotitle = "已经签过到了!";
        break;
      case QiandaoState.notQiandao:
        infotitle = "丸辣,没签到!";
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Card.outlined(
        child: ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text("$username $userid"),
          subtitle: Text(infotitle),
          trailing: IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.task_alt),
          ),
        ),
      ),
    );
  }
}
