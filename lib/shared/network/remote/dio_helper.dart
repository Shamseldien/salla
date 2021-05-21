import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';

abstract class DioHelper {
  Future<Response> postData({
    @required String url,
    @required dynamic data,
    String token,
  });

  Future<Response> getData({
    @required String url,
    String token,
    dynamic query,
  });

  Future<Response> putData({
    @required String url,
    @required dynamic data,
    String token,
  });

  Future<Response> delete({
    @required String url,
    String token,
  });
}

class DioImplementation extends DioHelper {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,
    ),
  );

  @override
  Future<Response> getData({String url, String token, query}) async {
    dio.options.headers = {
      'Authorization': token ?? '',
      'lang': appLanguage,
      'Content-Type': 'application/json',
    };

    return await dio.get(url, queryParameters: query);
  }

  @override
  Future<Response> postData({String url, data, String token})async {
    dio.options.headers = {
      'Authorization': token ?? '',
      'lang': appLanguage,
      'Content-Type': 'application/json',
    };

    return await dio.post(url,data: data,);

  }

  @override
  Future<Response> putData({String url, data, String token}) async{
    dio.options.headers = {
      'Authorization': token ?? '',
      'lang': appLanguage,
      'Content-Type': 'application/json',
    };

    return await dio.put(url,data: data,);
  }

  @override
  Future<Response> delete({String url, String token})async {
    dio.options.headers = {
      'Authorization': token ?? '',
      'lang': appLanguage,
      'Content-Type': 'application/json',
    };

    return await dio.delete(url,);

  }
}
