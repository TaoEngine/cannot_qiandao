part of '../widgets/dialog.dart';

QiandaoPlugin plugin = QiandaoPlugin();

/// 在登录弹窗按下"登录"时执行登录操作
Future<void> loginWithPlugin({
  required Function onrun,
  required Function oncallback,
  required Function(String) onerror,
  required String userid,
  required String password,
}) async {
  onrun();
  try {
    await plugin.login(
      userid: userid,
      password: password,
    );
    oncallback();
  } catch (error) {
    onerror.call(error.toString());
  }
}
