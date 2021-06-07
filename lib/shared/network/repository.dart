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

  Future<Response> userSignUp(
      {@required String userName,
      @required String email,
      @required String phone,
      @required String password,
      image});

  Future<Response> updateProfile(
      {String name,
      String email,
      String phone,
      String image,
      String password,
      token});

  Future<Response> getCategories();

  Future<Response> getHomeData({token});

  Future<Response> getFavorite({token});

  Future<Response> getOrderDetails({token, orderId});

  Future<Response> getOrders({token});

  Future<Response> cancelOrder({token, orderId});

  Future<Response> getAddresses({token});

  Future<Response> addAddress(
      {token,
      String name,
      String city,
      String region,
      String details,
      double latitude,
      double longitude,
      String notes});

  Future<Response> updateAddress({
    addressId,
    token,
    String name,
    String city,
    String region,
    String details,
    double latitude,
    double longitude,
    String notes,
  });

  Future<Response> addOrRemoveCart({token, id});

  Future<Response> addOrRemoveFav({token, id});

  Future<Response> getSingleCategory({token, id});

  Future<Response> getProductInfo({token, id});

  Future<Response> updateCart({token, id, quantity});

  Future<Response> getCartInfo({token});

  Future<Response> getUserProfile({token});

  Future<Response> confirmOrder(
      {token, int addressId, int payMethod, dynamic promo, bool points});

  Future<Response> deleteAddress({token, id});

  Future<Response> promoValidate({token, promo});

  Future<Response> estimateOrderCost({token, promoId});

  Future<Response> searchProducts({token, text});

  Future<Response> userLogout({
    @required String token,
  });
}

class RepositoryImplementation extends Repository {
  DioHelper dioHelper;
  CashHelper cashHelper;

  RepositoryImplementation(
      {@required this.cashHelper, @required this.dioHelper});

  @override
  Future<Response> userSignUp(
      {String userName,
      String email,
      String phone,
      String password,
      image}) async {
    return await dioHelper.postData(url: SIGN_UP_END_POINT, data: {
      'name': userName,
      'email': email,
      'phone': phone,
      'password': password,
      'image': image ?? ''
    });
  }

  @override
  Future<Response> usrLogin({String email, String password}) async {
    return await dioHelper.postData(
        url: LOGIN_END_POINT, data: {'email': email, 'password': password});
  }

  @override
  Future<Response> getCategories() async {
    return await dioHelper.getData(url: CATEGORIES_END_POINT);
  }

  @override
  Future<Response> getHomeData({token}) async {
    return await dioHelper.getData(url: HOME_DATA_END_POINT, token: token);
  }

  @override
  Future<Response> getFavorite({token}) async {
    return await dioHelper.getData(url: FAVORITE_END_POINT, token: token);
  }

  @override
  Future<Response> addOrRemoveCart({token, id}) async {
    return await dioHelper.postData(
        url: CART_END_POINT, data: {'product_id': id}, token: token);
  }

  @override
  Future<Response> addOrRemoveFav({token, id}) async {
    return await dioHelper.postData(
        url: ADD_FAVORITE_END_POINT, data: {'product_id': id}, token: token);
  }

  @override
  Future<Response> getSingleCategory({token, id}) async {
    return await dioHelper.getData(
        url: SINGLE_CATEGORY_POINT, query: {'category_id': id}, token: token);
  }

  @override
  Future<Response> getProductInfo({token, id}) async {
    return await dioHelper.getData(
        url: '$PRODUCT_INFO_POINT/$id', token: token);
  }

  @override
  Future<Response> getCartInfo({token}) async {
    return await dioHelper.getData(url: CART_END_POINT, token: token);
  }

  @override
  Future<Response> updateCart({token, id, quantity}) async {
    return await dioHelper.putData(
        url: '$CART_END_POINT/$id', token: token, data: {'quantity': quantity});
  }

  @override
  Future<Response> getAddresses({token}) async {
    return await dioHelper.getData(url: ADDRESS_END_POINT, token: token);
  }

  @override
  Future<Response> addAddress(
      {token,
      String name,
      String city,
      String region,
      String details,
      double latitude,
      double longitude,
      String notes}) async {
    return await dioHelper
        .postData(url: ADDRESS_END_POINT, token: token, data: {
      "name": name,
      "city": city,
      "region": region,
      "details": details,
      "latitude": latitude,
      "longitude": longitude,
      "notes": notes
    });
  }

  @override
  Future<Response> deleteAddress({token, id}) async {
    return await dioHelper.delete(
      token: token,
      url: '$ADDRESS_END_POINT/$id',
    );
  }

  @override
  Future<Response> confirmOrder(
      {token, int addressId, int payMethod, dynamic promo, bool points}) async {
    return await dioHelper
        .postData(url: ADD_ORDER_END_POINT, token: token, data: {
      'address_id': addressId,
      'payment_method': payMethod,
      'use_points': points,
      'promo_code_id': promo
    });
  }

  @override
  Future<Response> getUserProfile({token}) async {
    return await dioHelper.getData(url: PROFILE_END_POINT, token: token);
  }

  @override
  Future<Response> updateProfile(
      {String name,
      String email,
      String phone,
      String image,
      String password,
      token}) async {
    return await dioHelper
        .putData(url: UPDATE_PROFILE_END_POINT, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password ?? '',
      'image': image ?? '',
    });
  }

  @override
  Future<Response> getOrders({token}) async {
    return await dioHelper.getData(url: GET_ORDERS_END_POINT, token: token);
  }

  @override
  Future<Response> getOrderDetails({token, orderId}) async {
    return await dioHelper.getData(
      url: '$GET_ORDERS_END_POINT/$orderId',
      token: token,
    );
  }

  @override
  Future<Response> cancelOrder({token, orderId}) async {
    return await dioHelper.getData(
      url: '$GET_ORDERS_END_POINT/$orderId/$CANCEL_ORDERS_END_POINT',
      token: token,
    );
  }

  @override
  Future<Response> promoValidate({token, promo}) async {
    return await dioHelper.postData(
        url: PROMO_CODE_END_POINT, token: token, data: {'code': promo});
  }

  @override
  Future<Response> estimateOrderCost({token, promoId}) async {
    return await dioHelper.postData(
        url: ESTIMATE_ORDERS_END_POINT,
        token: token,
        data: {"use_points": false, "promo_code_id": promoId});
  }

  @override
  Future<Response> userLogout({String token}) async {
    return await dioHelper.postData(
        url: LOGOUT_END_POINT,
        token: token,
        data: {"fcm_token": "SomeFcmToken"});
  }

  @override
  Future<Response> searchProducts({token, text}) async {
    return await dioHelper
        .postData(url: SEARCH_END_POINT, token: token, data: {"text": "$text"});
  }

  @override
  Future<Response> updateAddress({
    addressId,
    token,
    String name,
    String city,
    String region,
    String details,
    double latitude,
    double longitude,
    String notes,
  }) async {
    return await dioHelper
        .putData(url: '${ADDRESS_END_POINT}/$addressId',token: token, data: {
      "name": name,
      "city": city,
      "region": region,
      "details": details,
      "latitude": latitude,
      "longitude": longitude,
      "notes": notes
    });
  }
}
