import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/local/cash_helper.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

abstract class Repository {
  Future<Response> usrLogin({
    @required String email,
    @required String password,
  });

  Future<Response> userSignUp({
    @required String userName,
    @required String email,
    @required String phone,
    @required String password,
  });

  Future<Response>getCategories();
  Future<Response>getHomeData({token});
  Future<Response>getFavorite({token});
  Future<Response>addOrRemoveCart({token,id});
  Future<Response>addOrRemoveFav({token,id});
  Future<Response>getSingleCategory({token,id});
  Future<Response>getProductInfo({token,id});
}

class RepositoryImplementation extends Repository {
  DioHelper dioHelper;
  CashHelper cashHelper;
  RepositoryImplementation({@required this.cashHelper,@required this.dioHelper});
  
  @override
  Future<Response> userSignUp(
      {String userName, String email, String phone, String password}) async{
   return await dioHelper.postData(url: SIGN_UP_END_POINT, data: {
      'name':userName,
      'email':email,
      'phone':phone,
      'password':password,
    });
  }

  @override
  Future<Response> usrLogin({String email, String password}) async{
   return await dioHelper.postData(url: LOGIN_END_POINT, data: {
     'email':email,
     'password':password
   });
  }


  @override
  Future<Response> getCategories()async {
    return await dioHelper.getData(url: CATEGORIES_END_POINT);
  }

  @override
  Future<Response> getHomeData({token}) async{
    return await dioHelper.getData(url: HOME_DATA_END_POINT,token: token);
  }

  @override
  Future<Response> getFavorite({token}) async{
    return await dioHelper.getData(url: FAVORITE_END_POINT,token: token);
  }

  @override
  Future<Response> addOrRemoveCart({token,id}) async{
    return await dioHelper.postData(
        url: CART_END_POINT,
        data: {
          'product_id':id
        },
        token: token);
  }

  @override
  Future<Response> addOrRemoveFav({token, id}) async{
    return await dioHelper.postData(
        url: FAVORITE_END_POINT,
        data: {
          'product_id':id
        },
        token: token);
  }

  @override
  Future<Response> getSingleCategory({token, id})async {
    return await dioHelper.getData(
        url: SINGLE_CATEGORY_POINT,
        query: {
          'category_id':id
        },
        token: token);
  }

  @override
  Future<Response> getProductInfo({token, id}) async{
    return await dioHelper.getData(
        url: '$PRODUCT_INFO_POINT/$id',
        token: token);

  }
}
