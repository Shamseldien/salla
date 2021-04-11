import 'package:salla/models/user_info/user_info_model.dart';

abstract class AuthStates {}
class AuthInitState extends AuthStates{}
class AuthLoadingState extends AuthStates{}
class AuthSuccessState extends AuthStates{

  UserInfoModel userInfoModel;
  AuthSuccessState(this.userInfoModel);
}
class AuthErrorState extends AuthStates{
  var error;
  AuthErrorState(this.error);
}
class AuthSelectImageState extends AuthStates{}
class AuthShowPassState extends AuthStates{}