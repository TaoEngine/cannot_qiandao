import 'package:cannot_qiandao/func/plugin.dart';
import 'package:cannot_qiandao/func/qiandao.dart';
import 'package:cannot_qiandao/func/requests.dart';
import 'package:flutter/material.dart';
import 'package:mmkv/mmkv.dart';

class URLDialog extends StatefulWidget {
  final Function onEditFunction;

  /// 规则URL输入弹窗
  const URLDialog({super.key, required this.onEditFunction});

  @override
  State<URLDialog> createState() => _URLDialogState();
}

class _URLDialogState extends State<URLDialog> {
  /// 规则URL，用于同步签到规则
  String _sourceURL = "";

  /// 同步规则URL输入框的信息
  late TextEditingController _urlController;

  /// 存放配置的数据库
  final MMKV _configDB = MMKV("configDB");

  @override
  void initState() {
    super.initState();
    _sourceURL = _configDB.decodeString("SourceURL") ?? "";
    _urlController = TextEditingController(text: _sourceURL);
  }

  void _updateSourceURL(String value) {
    setState(() {
      _sourceURL = value;
      _configDB.encodeString("SourceURL", _sourceURL);
      widget.onEditFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.power),
      title: const Text('规则URL'),
      content: const Text(
          '规则就像插件，和软件主体是分开的，这样可以灵活应对签到系统突发的更改\n规则将在APP启动时更新一次\n规则由TOML编写，有感兴趣的友友们可以和我一起交流哦！'),
      actions: [
        TextField(
          controller: _urlController,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '输入存放规则的URL',
          ),
          onChanged: _updateSourceURL, // 使用更新函数
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _sourceURL.isEmpty
              ? null
              : () {
                  // 这里可以增加错误处理
                  if (!Uri.parse(_sourceURL).isAbsolute) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("错误"),
                        content: const Text("请输入有效的URL"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("返回"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context);
                },
          child: const Text('完成'),
        ),
      ],
    );
  }
}

class UserDialog extends StatefulWidget {
  final Function onEditFunction;
  final Function onSaveFunction;
  final Function onErrorFunction;
  const UserDialog(
      {super.key,
      required this.onEditFunction,
      required this.onSaveFunction,
      required this.onErrorFunction});

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  /// 正在登录
  bool _isLogging = false;

  /// 登录的ID
  String? _userid;

  /// 登录的密码
  String? _password;

  /// 上一次登录的密码(MD5形式)
  String? _passwordpast;

  /// 用于显示toml插件的登录提示信息
  String? _logindescription;

  /// 给登录id的dialog用的
  TextEditingController _idController = TextEditingController();

  /// 调用签到插件
  final QiandaoPlugin _qiandaoPlugin = QiandaoPlugin();

  /// 存放登录的数据库
  final MMKV _loginDB = MMKV("loginDB");

  @override
  void initState() {
    super.initState();
    try {
      _qiandaoPlugin.loadPlugin("");
      _userid = _loginDB.decodeString("UserID");
      _idController = TextEditingController(text: _userid);
      _passwordpast = _loginDB.decodeString("PasswordMD5");
    } catch (error) {
      Navigator.pop(context);
      widget.onErrorFunction(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.login),
      title: const Text('登录签到系统'),
      content: Text(_logindescription ??
          "请先登录考勤系统,然后才能签到\n这里的登录信息将被用于本地获取token\n密码验证时会被转换为MD5编码格式被保存\n密码本体是不会被泄露的请你们放心"),
      actions: [
        TextField(
          controller: _idController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: '学号',
          ),
          onChanged: (value) {
            setState(() {
              _userid = value;
              _loginDB.encodeString("UserID", _userid);
              widget.onEditFunction();
            });
          },
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
            setState(() {
              _password = value;
              widget.onEditFunction();
            });
          },
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _userid == null ||
                  _password == null ||
                  _userid!.isEmpty ||
                  _password!.isEmpty ||
                  _isLogging
              ? null
              : () async {
                  setState(() {
                    _isLogging = true;
                  });
                  // 更新密码
                  final passwordmd5 = toMD5(_password!);
                  _loginDB.encodeString("PasswordMD5", passwordmd5);
                  try {
                    await _qiandaoPlugin.loadToken(loadName: "GetToken");
                    setState(() {
                      _isLogging = false;
                      Navigator.pop(context);
                      widget.onSaveFunction();
                    });
                  } catch (error) {
                    // 密码回滚
                    _loginDB.encodeString("PasswordMD5", _passwordpast);
                    setState(() {
                      _isLogging = false;
                      widget.onErrorFunction(error);
                    });
                  }
                },
          child: _isLogging
              ? const CircularProgressIndicator.adaptive()
              : const Text("登录"),
        )
      ],
    );
  }
}
