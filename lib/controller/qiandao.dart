part of '../pages/qiandao.dart';

QiandaoPlugin plugin = QiandaoPlugin();

Future<List<Widget>> loadUserCards() async {
  /// 放用户组件的List,
  /// 有多少用户就放多少用户组件的卡片,
  /// 不过现在只能做一个用户的,别急
  List<Widget> usercards = [];

  // 获取保存的所有用户姓名,学号和token
  List<String> usersinfo = plugin.getuserinfo();

  late QiandaoState qiandaoState;
  final bool isQiandao = await plugin.getstate();
  final Map<String, dynamic> todayTask = await plugin.gettask();
  final DateTime nowTime = DateTime.now();

  // 检测现在属于那种签到类型
  if (isQiandao) {
    qiandaoState = QiandaoState.cannotQiandao;
  } else {
    if (nowTime.isBefore(todayTask["timestart"])) {
      qiandaoState = QiandaoState.notneedQiandao;
    } else if (nowTime.isBefore(todayTask["timestop"])) {
      qiandaoState = QiandaoState.needQiandao;
    } else if (nowTime.isAfter(todayTask["timestop"])) {
      qiandaoState = QiandaoState.notQiandao;
    }
  }

  // 添加到签到数据库
  usercards.add(
    QiandaoCard(
      userid: usersinfo[0],
      username: usersinfo[1],
      qiandaoState: qiandaoState,
    ),
  );
  return usercards;
}
