import 'dart:convert';
import 'dart:io' as IO;
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salla/modules/profile/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  Repository repository;

  EditProfileCubit(this.repository) : super(EditProfileStateInit());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  Future updateProfile({
    name,
    email,
    pass,
    phone,
    context
  }) async{
    emit(EditProfileStateLoading());
   await repository.updateProfile(
      token: userToken,
      image: base64Str,
      name: name,
      email: email,
      password: pass,
      phone: phone
    ).then((value) {
      if(value.data['status']){
        showToast(text: value.data['message'], color: toastMessagesColors.SUCCESS);
        AppCubit.get(context).getUserInfo().then((value){
          emit(EditProfileStateSuccess());
        }).catchError((error){
          print(error.toString());
          emit(EditProfileStateError(error));
        });
      }else{
        showToast(text: value.data['message'], color: toastMessagesColors.ERROR);
        emit(EditProfileStateError(value.data['message']));
      }
    }).catchError((error) {
      print(error.toString());
      emit(EditProfileStateError(error));
    });
  }

  File image;
  final picker = ImagePicker();
  var base64Str ='';


  Future  getImage({@required ImageSource source}) async {
   // emit(AuthSelectImageLoadingState());
    final pickedFile = await picker.getImage(source: source, );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      List<int> imageBytes = image.readAsBytesSync();
      base64Str = base64Encode(imageBytes);
      emit(EditProfileStateSuccess());
    } else {
      print('No image selected.');
    }

  }


}
