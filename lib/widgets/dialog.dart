import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class URLDialog extends StatefulWidget {
  const URLDialog({super.key});

  @override
  State<URLDialog> createState() => _URLDialogState();
}

class _URLDialogState extends State<URLDialog> {
  static const String infotext =
      '插件和软件主体是分开的，这样可以灵活应对签到系统突发的更改\n插件将在APP启动时更新一次\n插件由TOML编写，有感兴趣的友友们可以和我一起交流哦！';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.link),
      title: const Text('编辑插件URL'),
      content: const Text(infotext),
      actions: [
        const TextField(
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: '输入存放规则的URL',
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: const Text('完成'),
        ),
      ],
    );
  }
}

class UserDialog extends StatefulWidget {
  const UserDialog({super.key});

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  static const String infotext =
      "请先登录考勤系统,然后才能签到\n这里的登录信息将被用于本地获取token\n密码验证时会被转换为MD5编码格式被保存\n密码本体是不会被泄露的请你们放心";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.login),
      title: const Text('登录签到系统'),
      content: const Text(infotext),
      actions: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '学号',
          ),
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '密码',
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: const Text("登录"),
        )
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  /// 出错信息
  ///
  /// 如果向系统发送消息或者回传消息的时候出现一些错误(比如签到系统卡住了,不合规的消息被传出),
  /// HTTP模块就会返回标准错误
  ///
  /// 将标准错误传入此处,出了错误就能及时去处理
  final String errorcontent;

  /// 出错的弹窗
  const ErrorDialog({
    super.key,
    required this.errorcontent,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.error),
      title: const Text("出错了"),
      content: Text(errorcontent),
      actions: [
        TextButton(
          onPressed: () => launchUrl(
            Uri.parse(
                "https://github.com/TaoEngine/cannot_qiandao/issues/new?labels=bug&title=我的签到APP出现了问题&body=问题是这样的:$errorcontent"),
          ),
          child: const Text("向我提问"),
        ),
        TextButton(
          onPressed: () {},
          child: const Text("重试"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("关闭"),
        ),
      ],
    );
  }
}
