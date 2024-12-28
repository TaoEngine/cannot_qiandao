import 'package:cannot_qiandao/func/plugin.dart';
import 'package:cannot_qiandao/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cannot_qiandao/pages/qiandao.dart';
import 'package:cannot_qiandao/pages/settings.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  QiandaoPlugin initplugin = QiandaoPlugin();
  await initplugin.init();
  runApp(const MainAPP());
}

class MainAPP extends StatelessWidget {
  const MainAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
      return MaterialApp(
        title: '没必要签到',
        theme: ThemeData(
          colorScheme: lightDynamic,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('zh', 'CN')],
        home: const MainPage(),
      );
    });
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("没必要签到"),
        actions: [
          // 登录按钮
          IconButton(
            onPressed: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (builder) => const UserDialog(),
            ),
            icon: const Icon(Icons.login),
            tooltip: "登录",
          ),
          // 编辑按钮
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (builder) => const EditDialog(),
            ),
            icon: const Icon(Icons.edit),
            tooltip: "编辑",
          ),
          // 设置按钮
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const SettingsPage();
              }),
            ),
            icon: const Icon(Icons.settings),
            tooltip: "设置",
          ),
        ],
      ),
      body: const QiandaoPage(),
    );
  }
}
