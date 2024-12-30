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
  /// 使用Get或Post请求并返回期望的数据
  ///
  /// [url] 请求的URL
  /// [method] 请求方法（GET或POST）
  /// [headers] 请求头
  /// [body] 请求体（仅在POST请求时使用）
  /// [query] 查询参数
  /// [expect] 期望的响应数据路径
  Future<Map<String, String>> beginRequestDecode({
    required Uri url,
    required HttpMethod method,
    Map<String, String>? headers,
    Object? body,
    Map<String, String>? query,
    Map<String, String>? expect,
  }) async {
    // 1. 为URL添加查询参数
    var queryURL = Uri(
      scheme: url.scheme,
      host: url.host,
      path: url.path,
      queryParameters: query,
    );

    final Object? bodyEncoded;

    // 鉴别body是否要以json方式进行传递
    if (headers!["Content-Type"]!.contains("json")) {
      bodyEncoded = json.encode(body);
    } else {
      bodyEncoded = body;
    }

    Map<String, String> response = {};
    try {
      // 2. 发起HTTP请求
      final responseRaw = await (method == HttpMethod.methodGET
              ? http.get(queryURL, headers: headers)
              : http.post(queryURL, headers: headers, body: bodyEncoded))
          .timeout(const Duration(seconds: 10));

      // 3. 检查响应状态码
      if (responseRaw.statusCode == 200) {
        if (expect != null) {
          // 4. 解码响应体
          try {
            Map<String, dynamic> responseDecoded =
                json.decode(responseRaw.body);
            // 5. 提取期望的数据
            for (var entry in expect.entries) {
              String key = entry.key;
              String value = entry.value;

              if (value.contains(".")) {
                List<String> pathParts = value.split(".");
                dynamic currentValue = responseDecoded;
                try {
                  for (var part in pathParts) {
                    if (currentValue is Map && currentValue.containsKey(part)) {
                      currentValue = currentValue[part];
                    } else {
                      throw RangeError("找不到路径 $value");
                    }
                  }
                  response[key] = currentValue.toString();
                } catch (e) {
                  throw RangeError("解析路径 $value 失败: $e");
                }
              } else {
                if (responseDecoded.containsKey(value)) {
                  response[key] = responseDecoded[value].toString();
                } else {
                  throw RangeError("找不到键 $value");
                }
              }
            }
          } on FormatException catch (e) {
            throw Exception("JSON 解析失败: $e");
          } catch (e) {
            throw Exception("数据解析失败: $e");
          }
        } else {
          return {};
        }
      } else {
        throw Exception(
            "服务器返回了一个${responseRaw.statusCode}错误,要不检查一下?\n问题是${responseRaw.body}");
      }
    } on SocketException {
      throw Exception("连接不上网址,稍后再试试看");
    } on TimeoutException {
      throw Exception("网址连接过于缓慢,稍后再试试看");
    } on HandshakeException {
      throw Exception("网址证书失效了,注意你的设备是不是变得不安全了");
    } catch (error) {
      rethrow;
    }
    return response;
  }

  Future<String> beginRequest({
    required Uri url,
    required HttpMethod method,
    Map<String, String>? headers,
    Map<String, String>? body,
    Map<String, String>? query,
  }) async {
    // 1. 为URL添加查询参数
    var queryURL = Uri(
      scheme: url.scheme,
      host: url.host,
      path: url.path,
      queryParameters: query,
    );

    try {
      // 2. 发起HTTP请求
      final responseRaw = await (method == HttpMethod.methodGET
              ? http.get(queryURL, headers: headers)
              : http.post(queryURL, headers: headers, body: body))
          .timeout(const Duration(seconds: 10));

      // 3. 检查响应状态码
      if (responseRaw.statusCode == 200) {
        // 4. 返回原始响应体
        return responseRaw.body;
      } else {
        throw Exception(
            "服务器返回了一个${responseRaw.statusCode}错误,问题是${responseRaw.body},要不检查一下?");
      }
    } on SocketException {
      throw Exception("连接不上网址,稍后再试试看");
    } on TimeoutException {
      throw Exception("网址连接过于缓慢,稍后再试试看");
    } on HandshakeException {
      throw Exception("网址证书失效了,注意你的设备是不是变得不安全了");
    } catch (error) {
      rethrow;
    }
  }
}
