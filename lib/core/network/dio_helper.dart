import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://newsapi.org/',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '2e0d0d936d6e4ad6a5e3c3ec6c32c5e1',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': token != null ? 'Bearer $token' : '2e0d0d936d6e4ad6a5e3c3ec6c32c5e1',
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': token != null ? 'Bearer $token' : '2e0d0d936d6e4ad6a5e3c3ec6c32c5e1',
    };
    return await dio.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': token != null ? 'Bearer $token' : '2e0d0d936d6e4ad6a5e3c3ec6c32c5e1',
    };
    return await dio.put(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': token != null ? 'Bearer $token' : '2e0d0d936d6e4ad6a5e3c3ec6c32c5e1',
    };
    return await dio.delete(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> patchData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Authorization': token != null ? 'Bearer $token' : '2e0d0d936d6e4ad6a5e3c3ec6c32c5e1',
    };
    return await dio.patch(
      url,
      data: data,
      queryParameters: query,
    );
  }
} 