import 'package:dio/dio.dart';
import 'package:intellij_tourism_designer/http/rsp_interceptor.dart';
import '../constants/constants.dart';

class Dio_database{
  static Dio_database? _instance;

  Dio_database._();

  static Dio_database instance(){
    return _instance ??= Dio_database._();
  }

  final Dio _dio = Dio(
      BaseOptions(
          method: "GET",
          baseUrl: "http://121.41.170.185:5000/",
          connectTimeout: defaultTime,
          receiveTimeout: Duration(seconds: 60),
          sendTimeout: defaultTime,
          responseType: ResponseType.json,
          persistentConnection: true
      )
  );

  void initDio() => _dio.interceptors.add(ResponseInterceptor());


  Future<Response> get({
    required String path,
    Map<String,dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
})async{
    return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options??Options(method: "GET", receiveTimeout: defaultTime, sendTimeout: defaultTime),
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
        options: options??Options(
            method: "POST",
            receiveTimeout: Duration(seconds: 60),
            sendTimeout: defaultTime),
        cancelToken: cancelToken
    );
  }
}

class Dio_gaode{
  static Dio_gaode? _instance;

  Dio_gaode._();

  static Dio_gaode instance(){
    return _instance ??= Dio_gaode._();
  }

  final Dio _dio = Dio(
      BaseOptions(
          method: "GET",
          baseUrl: "https://restapi.amap.com/v3/",
          connectTimeout: defaultTime,
          receiveTimeout: defaultTime,
          sendTimeout: defaultTime,
          responseType: ResponseType.json,
          persistentConnection: true
      )
  );

  Future<Response> get({
    required String path,
    Map<String,dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  })async{
    return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options??Options(method: "GET", receiveTimeout: defaultTime, sendTimeout: defaultTime),
        cancelToken: cancelToken
    );
  }

}

class Dio_enterprise{
  static Dio_enterprise? _instance;

  Dio_enterprise._();

  static Dio_enterprise instance(){
    return _instance ??= Dio_enterprise._();
  }

  final Dio _dio = Dio(
      BaseOptions(
          method: "GET",
          baseUrl: "http://182.92.251.24:8080/",
          connectTimeout: defaultTime,
          receiveTimeout: defaultTime,
          sendTimeout: defaultTime,
          responseType: ResponseType.json,
          persistentConnection: true
      )
  );

  Future<Response> get({
    required String path,
    Map<String,dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  })async{
    return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options??Options(method: "GET", receiveTimeout: defaultTime, sendTimeout: defaultTime),
        cancelToken: cancelToken
    );
  }
}

class Dio_qw{
  static Dio_qw? _instance;

  Dio_qw._();

  static Dio_qw instance(){
    return _instance ??= Dio_qw._();
  }

  final Dio _dio = Dio(
      BaseOptions(
          method: "GET",
          baseUrl: "https://devapi.qweather.com/v7/",
          connectTimeout: defaultTime,
          receiveTimeout: defaultTime,
          sendTimeout: defaultTime,
          responseType: ResponseType.json,
          persistentConnection: true
      )
  );

  Future<Response> get({
    required String path,
    Map<String,dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  })async{
    return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options??Options(method: "GET", receiveTimeout: defaultTime, sendTimeout: defaultTime),
        cancelToken: cancelToken
    );
  }

}
