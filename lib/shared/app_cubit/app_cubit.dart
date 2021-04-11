import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/banners_model/banner_model.dart';
import 'package:salla/models/categories_model/categories_model.dart';
import 'package:salla/models/favorites/favorites_model.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:salla/modules/home/home.dart';
import 'package:salla/modules/settings/settings.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/language/language_model.dart';
import 'package:salla/shared/network/repository.dart';

class AppCubit extends Cubit<AppStates>{
  Repository repository;
  AppCubit({this.repository}):super(AppStateInit());

  static AppCubit get(context)=>BlocProvider.of(context);

  List<bool> selectedLanguage = [
    false,
    false,
  ];

  int selectedLanguageIndex;

  void changeSelectedLanguage(int index) {
    selectedLanguageIndex = index;

    for (int i = 0; i < selectedLanguage.length; i++) {
      if (i == index) {
        selectedLanguage[i] = true;
      } else {
        selectedLanguage[i] = false;
      }
    }

    emit(AppStateSelectLang());
  }
AppLanguageModel appLanguageModel;

 TextDirection appDirection = TextDirection.ltr;

 Future<void>setAppLanguage({translationFile,code})async {
    appLanguageModel = AppLanguageModel.fromJson(jsonDecode(translationFile));
    appDirection =await code == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    emit(AppSetLanguageState());
  }


  BannersModel bannersModel;
  CategoriesModel categoriesModel;
  HomeModel homeModel;
  FavoritesModel favoriteModel;


  void getCategories() {
    //  emit(HomeLoadingState());
    repository.getCategories().then((value){
      categoriesModel = CategoriesModel.fromJson(value.data);
      print(categoriesModel.status);
      emit(AppStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(AppStateError(error));
    });
  }
  List<Widget> pages = [
    HomeScreen(),
    Center(child: Text('category')),
    Center(child: Text('cart')),
    SettingsScreen(),

  ];

  void getHomeData() {
    //  emit(HomeLoadingState());
    repository.getHomeData(token: userToken).then((value){
      print(userToken);
      homeModel = HomeModel.fromJson(value.data);
      print(homeModel.status);
      emit(AppStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(AppStateError(error));
    });
  }

  void getFavorites() {
    //  emit(HomeLoadingState());
    repository.getFavorite(token: userToken).then((value){
      print(userToken);
      favoriteModel = FavoritesModel.fromJson(value.data);
      emit(AppStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(AppStateError(error));
    });
  }

}