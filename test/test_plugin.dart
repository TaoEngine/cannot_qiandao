import 'package:cannot_qiandao/func/requests.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cannot_qiandao/func/plugin.dart';

void main() async {
  final plugin = QiandaoPlugin();
  test('测试能不能连接到服务器', () async {
    await plugin.init();
    await plugin.seturl(
      url: "http://127.0.0.1:8000/plugin/kqxt.toml",
    );
    await plugin.login(userid: "229094328", password: "Wzry20040423");
    var aa = await plugin.gettoken();
    print(aa);
    var bb = await plugin.getstate();
    print(bb);
    var cc = await plugin.gettask();
    print(cc);
    var dd = await plugin.qiandao();
    print(dd);
  });
}
