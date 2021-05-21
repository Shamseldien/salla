import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salla/models/user_info/user_info_model.dart';
import 'package:salla/modules/authentication/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/network/repository.dart';

class AuthCubit extends Cubit<AuthStates> {
  final Repository repository;

  AuthCubit({@required this.repository}) : super(AuthInitState());

  static AuthCubit get(context) => BlocProvider.of(context);

  File image;
  final picker = ImagePicker();
  String base64Image ='' ;
  bool isShow = false;

  UserInfoModel userInfoModel;


  Future<String> getImage({@required ImageSource source}) async {
    String _base64Image ;
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);
    if (pickedFile != null) {

      image = File(pickedFile.path);
    //  List<int> imageBytes = image.readAsBytesSync();
     // _base64Image = base64Encode(imageBytes);
      //print('from here ==> $_base64Image <==to here');
      emit(AuthSelectImageState());
    } else {
      print('No image selected.');
    }
    return _base64Image;
  }

  userLogin({@required email, @required password}) {
    emit(AuthLoadingState());
    repository.usrLogin(email: email, password: password).then((value) {
      userInfoModel = UserInfoModel.fromJson(value.data);
      if(userInfoModel.status){
        emit(AuthSuccessState(userInfoModel));
      }else{
        showToast(text: userInfoModel.message, color: toastMessagesColors.ERROR);
        emit(AuthErrorState(value.data['message']));
      }
    }).catchError((error) {
      print(error.toString());
      emit(AuthErrorState(error));
    });
  }

  userRegistration(
      {@required email,
      @required phone,
      @required name,
      @required password,

      }) {
    emit(AuthLoadingState());
    repository
        .userSignUp(
      userName: name,
      email: email,
      phone: phone,
      password: password,
    ).then((value) {
      userInfoModel = UserInfoModel.fromJson(value.data);
      if(userInfoModel.status){
        emit(AuthSuccessState(userInfoModel));
      }else{
        showToast(text: userInfoModel.message, color: toastMessagesColors.ERROR);
        emit(AuthErrorState(userInfoModel.message));
      }
    }).catchError((error) {
      print(error.toString());
      emit(AuthErrorState(error));
    });
  }

  togglePass(){
    isShow = !isShow;
    emit(AuthShowPassState());
  }
}
