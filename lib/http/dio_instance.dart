import 'package:dio/dio.dart';
import 'package:intellij_tourism_designer/http/rsp_interceptor.dart';

class DioInstance{
  static DioInstance? _instance;

  DioInstance._();

  static DioInstance instance(){
    return _instance ??= DioInstance._();
  }

  final Dio _dio = Dio();
  final Duration _defaultTime = const Duration(seconds: 30);

  void initDio({
    required String baseUrl,
    String? httpMethod = "GET",
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType,
    String? contentType,}
  ){
    _dio.options = BaseOptions(
        method: httpMethod,
        baseUrl: baseUrl,
        connectTimeout: connectTimeout??_defaultTime,
        receiveTimeout: receiveTimeout??_defaultTime,
        sendTimeout: sendTimeout??_defaultTime,
        responseType: responseType??ResponseType.json,
        contentType: contentType,
    );
    _dio.interceptors.add(ResponseInterceptor());
  }

  Future<Response> get({
    required String path,
    Map<String,dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
})async{
    return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options??Options(method: "GET", receiveTimeout: _defaultTime, sendTimeout: _defaultTime),
        cancelToken: cancelToken
    );
  }

  Future<Response> post({
    required String path,
    Object? data,
    Map<String,dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken
})async{
    return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options??Options(method: "POST", receiveTimeout: _defaultTime, sendTimeout: _defaultTime),
        cancelToken: cancelToken
    );
  }
}