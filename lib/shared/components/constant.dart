import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/language/language_model.dart';
import 'package:salla/shared/network/local/cash_helper.dart';

const String APP_LANG_KEY='appLang';
const String APP_DIRECTION_KEY='appDirection';
const String USER_TOKEN_KEY='token';
const String USER_Model_Info_KEY='userInfo';
const String THEME_MODE_KEY='themeMode';
const String SEARCH_HISTORY_KEY='searchHistory';
String appLanguage ='';
String userToken ='';


Future<bool> saveLanguageCode(code)async{
  appLanguage = code;
  return await di<CashHelper>().put(key: APP_LANG_KEY, value: code);
}

Future<bool>saveThemeMode({isDark})async{
  return await di<CashHelper>().put(key: THEME_MODE_KEY, value: isDark);
}
Future<bool>saveSearchHistory({value})async{
  return await di<CashHelper>().put(key: SEARCH_HISTORY_KEY, value: value);
}

Future getSearchHistory()async {
  return await di<CashHelper>().get(key: SEARCH_HISTORY_KEY);
}

Future<bool>clearSearchHistory()async{
  return await di<CashHelper>().clear(key: SEARCH_HISTORY_KEY);
}

Future<bool>getThemeMode()async {
  return await di<CashHelper>().get(key: THEME_MODE_KEY);
}

Future<String>getUserToken()async {
  return await di<CashHelper>().get(key: USER_TOKEN_KEY);
}

Future<String> getLangCode()async{
  return await di<CashHelper>().get(key: APP_LANG_KEY);
}


Future<String>getTranslationFile(appLang)async{
  return await rootBundle.loadString('assets/translation/${appLang ?? 'en'}.json');
}

Future<bool> deleteUserToken() async
{
  return await di<CashHelper>().clear(key:USER_TOKEN_KEY);
}

AppLanguageModel appLang(context) => AppCubit.get(context).appLanguageModel;


