import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

/// HTTP请求方法
enum HttpMethod {
  methodGET,
  methodPOST,
}

/// HTTP请求模块
class HttpUtil {
  /// 使用Get请求并返回想要的数据
  beginRequestDecode(
    Uri url,
    HttpMethod method,
    Map<String, String> head,
    Map<String, String>? body,
    Map<String, String>? query,
    Map<String, String> expect,
  ) async {
    // 1.为url加入query参数
    var queryURL = Uri(
      scheme: url.scheme,
      host: url.host,
      path: url.path,
      queryParameters: query,
    );

    Map<String, String> response = {};
    try {
      // 1.开始请求获取签到状态,然后就能获取签到是否成功
      var responseRaw = method == HttpMethod.methodGET
          ? await http.get(
              queryURL,
              headers: head,
            )
          : await http.post(
              queryURL,
              headers: head,
              body: body,
            );
      Map responseDecoded = json.decode(responseRaw.body);
      // 2.需要获取到的是Code200的值
      if (responseRaw.statusCode == 200) {
        // 3.筛选哪些数据是我们需要的
        Map expectNew = {};
        expect.forEach((key, value) {
          // 3.1.将含有点的元素分割为几个List
          if (value.contains(".")) {
            List<String> splitValue = value.split(".");
            expectNew.addAll({key: splitValue});
          } else {
            expectNew.addAll({key: value});
          }
        });

        // 4.遍历返回数据,找出我们要的数据
        bool contentExpect = false;
        expectNew.forEach((expectKey, expectValue) {
          if (expectValue is List) {
            // 4.1.期望的是深层次的数据(以列表形式呈现)
            try {
              var currentValue = responseDecoded[expectValue.first];
              for (var i = 1; i < expectValue.length; i++) {
                currentValue = currentValue[expectValue[i]];
              }
              contentExpect = true;
              response.addAll({expectKey: currentValue});
            } catch (_) {}
          } else if (expectValue is String) {
            // 4.2.期望的是浅层次的数据(以字符串形式呈现)
            responseDecoded.forEach((responseKey, responseValue) {
              if (expectValue == responseKey) {
                contentExpect = true;
                response.addAll({expectKey: responseValue});
              }
            });
          }
        });
        // 找不到就是有问题
        if (!contentExpect) {
          throw RangeError("我们找不到有效的期望内容,请检查Toml内容");
        }
      } else if (responseRaw.statusCode == 400) {
        if (responseDecoded["error"] == "invalid_grant") {
          throw Exception("登录失败,请检查学号和密码是否一致");
        } else {
          throw Exception("token失效了,请重新获取token");
        }
      } else {
        throw Exception(
            "服务器返回了一个${responseRaw.statusCode}错误,问题是:${responseDecoded["msg"]},要不检查一下?");
      }
    } catch (error) {
      if (error is SocketException) {
        throw Exception("连接不上网址,稍后再试试看");
      } else if (error is TimeoutException) {
        throw Exception("网址连接过于缓慢,稍后再试试看");
      } else if (error is HandshakeException) {
        throw Exception("网址证书失效了,注意你的设备是不是变得不安全了");
      } else {
        rethrow;
      }
    }
    return response;
  }
}
