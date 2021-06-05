import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CashHelper{
  Future  get({@required String key});
  Future<bool> put({@required String key,@required dynamic value});
  Future<bool> has({@required String key});
  Future<bool> clear({@required String key});
}


class CashImplementation extends CashHelper{
  final SharedPreferences _preferences;
  CashImplementation(this._preferences);
  @override
  Future<bool> clear({String key}) async{
   final bool f = await _basicErrorHandling(()async{
     return await _preferences.remove(key);
   });
   return f;
  }

  @override
  Future get({String key})async {
    final f = await _basicErrorHandling(() async {
      if (await has(key:key)) {
        return await jsonDecode(_preferences.getString(key));
      }
      return null;
    });
    return f;
  }

  @override
  Future<bool> has({String key}) async{
    final bool f = await _basicErrorHandling(() async {
      return _preferences.containsKey(key) && _preferences.getString(key).isNotEmpty;
    });
    return f;
  }

  @override
  Future<bool> put({String key, value}) async{
    final bool f = await _basicErrorHandling(()async{

      return await _preferences.setString(key, jsonEncode(value));
    });
    return f;
  }


}
extension on CashHelper
{
  Future<T> _basicErrorHandling<T>(Future<T> onSuccess()) async {
    try {
      final f = await onSuccess();
      return f;
    } catch (e)
    {
      print(e);
    }
  }
}