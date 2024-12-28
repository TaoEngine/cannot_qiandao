import 'package:flutter_test/flutter_test.dart';
import 'package:cannot_qiandao/func/plugin.dart';

void main() async {
  final QiandaoPlugin plugin = QiandaoPlugin();
  test('测试能不能连接到服务器', () async {
    await plugin.init();
    await plugin.login(userid: "229094245", password: "Ahgydx@920");
    expect(plugin.islogin, true);
    var aa = plugin.getuserinfo();
    print(aa);
    var cc = await plugin.gettask();
    print(cc);
    await plugin.qiandao();
    var bb = await plugin.getstate();
    print(bb);
  });
}
