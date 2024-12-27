import 'package:cannot_qiandao/func/requests.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cannot_qiandao/func/plugin.dart';

void main() async {
  final plugin = Plugin();
  test('测试能不能连接到服务器', () async {
    await plugin.init();
    await plugin.changePluginURL("http://127.0.0.1:8000/plugin/kqxt.toml");
    await plugin.changeUserInfo("229094229", "Ahgydx@920");
    print(plugin.gettoken());
    print(plugin.getusername());
    print(await plugin.getState());
  });
}
