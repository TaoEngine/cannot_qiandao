import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cannot_qiandao/pages/qiandao.dart';
import 'package:cannot_qiandao/pages/settings.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:mmkv/mmkv.dart';

void main() async {
  await MMKV.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
  /// 页面切换器，用于切换页面
  List<Widget> appPage = [
    const QiandaoPage(),
    const SettingsPage(),
  ];

  /// 监听底部导航栏按到了哪一个
  int naviCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appPage[naviCounter],
      bottomNavigationBar: NavigationBar(
        selectedIndex: naviCounter,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_alt),
            selectedIcon: Icon(Icons.check_circle),
            label: '去签到',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '调设置',
          ),
        ],
        onDestinationSelected: (value) {
          setState(() {
            naviCounter = value;
          });
        },
      ),
    );
  }
}
