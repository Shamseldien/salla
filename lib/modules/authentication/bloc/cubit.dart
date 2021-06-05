import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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


  Future  getImage({@required ImageSource source}) async {
    emit(AuthSelectImageLoadingState());
    final pickedFile = await picker.getImage(source: source, );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      List<int> imageBytes = image.readAsBytesSync();
      base64Image = base64Encode(imageBytes);
      emit(AuthSelectImageState());
    } else {
      print('No image selected.');
    }

  }


  void chooseSourceImageDialog(context){
    showBottomSheet(
      context: context,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0)
        ),
      ),
      builder: (context) {
        return chooseImageDialog(context: context);
      },
    );
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
      image: base64Image
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
