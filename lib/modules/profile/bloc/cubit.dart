import 'dart:convert';
import 'dart:io' as IO;
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salla/modules/profile/bloc/states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  Repository repository;

  EditProfileCubit(this.repository) : super(EditProfileStateInit());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  void updateProfile({
    name,
    email,
    pass,
    phone,
    image,
  }) {
    repository.updateProfile(
      token: userToken,
      image: image,
      name: name,
      email: email,
      password: pass,
      phone: phone
    ).then((value) {
      if(value.data['status']){
        showToast(text: value.data['message'], color: toastMessagesColors.SUCCESS);
        emit(EditProfileStateSuccess());
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

  Future<File> getImage({@required ImageSource source}) async {
    final pickedFile = await picker.getImage(source: source,imageQuality: 100,maxHeight: 500,maxWidth: 500);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(EditProfileStateSuccess());
    } else {
      print('No image selected.');
    }
   return image;
  }

}
