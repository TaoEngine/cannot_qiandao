import 'package:location/location.dart';

/// 插件解析器,替换插件提供的{{}}内容
Future<Map<String, dynamic>> replacedata({
  required MapEntry entry,
  required bool needlocation,
  String? userid,
  String? passwordmd5,
  String? token,
}) async {
  // 创建一个新的entry值，以便修改
  Map<String, dynamic> updatedEntryValue = {};

  // 映射所需的现在的信息
  String nowdate = _nowdate();
  String nowweek = _nowweek();
  String nowtime = _nowtime();
  List<String> nowlocation = await _nowlocation(needlocation);

  // 2.开始替换
  for (var queryValue in entry.value.entries) {
    if (queryValue.value is String) {
      // 替换字符串中的{{}}内容
      updatedEntryValue[queryValue.key] = queryValue.value
          .replaceAll("{{userid}}", userid ?? "null")
          .replaceAll("{{password}}", passwordmd5 ?? "null")
          .replaceAll("{{token}}", token ?? "null")
          .replaceAll("{{nowdate}}", nowdate)
          .replaceAll("{{nowweek}}", nowweek)
          .replaceAll("{{nowtime}}", nowtime)
          .replaceAll("{{nowlatitude}}", nowlocation[0])
          .replaceAll("{{nowlongitude}}", nowlocation[1])
          .replaceAll("{{nowaccuracy}}", nowlocation[2]);
    } else if (queryValue.value is Map) {
      // 替换Map中的值
      Map<String, String> updatedMapValue = {};
      for (var queryValueEntry in queryValue.value.entries) {
        updatedMapValue[queryValueEntry.key] = queryValueEntry.value
            .replaceAll("{{userid}}", userid ?? "null")
            .replaceAll("{{password}}", passwordmd5 ?? "null")
            .replaceAll("{{token}}", token ?? "null")
            .replaceAll("{{nowdate}}", "2024-12-18");
      }
      updatedEntryValue[queryValue.key] = updatedMapValue;
    }
  }
  return updatedEntryValue;
}

/// 当前日期
String _nowdate() {
  DateTime now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
}

/// 当前周数
String _nowweek() {
  DateTime now = DateTime.now();
  List<String> weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];

  // 计算今天是星期几，注意 Dart 中的 week starts from Monday (1)
  int weekdayIndex = now.weekday;

  return weekdays[weekdayIndex - 1];
}

/// 当前时间
String _nowtime() {
  DateTime now = DateTime.now();
  return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
}

/// 当前位置
Future<List<String>> _nowlocation(bool enable) async {
  if (enable) {
    Location location = Location();
    LocationData locationData = await location.getLocation();
    return [
      locationData.latitude.toString(),
      locationData.longitude.toString(),
      locationData.accuracy.toString(),
    ];
  }

  return [
    "0",
    "0",
    "0",
  ];
}
