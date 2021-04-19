import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/cart/cart_model.dart';
import 'package:salla/models/categories_model/categories_model.dart';
import 'package:salla/models/favorites/favorites_model.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:salla/modules/cart/cart.dart';
import 'package:salla/modules/categories/categories.dart';
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


  CategoriesModel categoriesModel;
  HomeModel homeModel;
  FavoritesModel favoriteModel;
  CartModel cartModel;
  int cartProductsNumber=0;
  Map<int,bool>inCart={};
  Map<int,bool>inFav={};
  List<Color> bottomColors=[
    Colors.deepOrangeAccent,
    Colors.teal,
    Colors.deepPurple,
    Colors.orange,

  ];


  int currentIndex=0;
  void changeIndex(index){
    currentIndex = index;
    emit(ChangeIndex());
  }
  void getCategories() {
     emit(AppStateLoading());
    repository.getCategories().then((value){
      categoriesModel = CategoriesModel.fromJson(value.data);
      print(categoriesModel.status);
     //emit(AppStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(AppStateError(error));
    });
  }
  List<Widget> pages = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    SettingsScreen(),

  ];

  void getHomeData() {
    //  emit(AppStateLoading());
    repository.getHomeData(token: userToken).then((value){
      print(userToken);
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
          inCart.addAll({element.id: element.inCart});
          inFav.addAll({element.id:element.inFavorites});
          if(element.inCart)
            cartProductsNumber++;
      });
      emit(AppStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(AppStateError(error));
    });
  }

  void addOrRemoveFavorite({id}){
    inFav[id]=!inFav[id];
    emit(CartLoadingState());
    repository.addOrRemoveFav(
      token: userToken,
      id: id,
    ).then((value){
      cartModel=CartModel.fromJson(value.data);
      if(!cartModel.status){
        inFav[id]=!inFav[id];
      }
      emit(AddToOrRemoveCartState());
    }).catchError((error){
      inFav[id]=!inFav[id];
      print(error);
      emit(CartErrorState(error));
    });
  }


  void addOrRemoveCart({id}){
     changeLocalCart(id);
    emit(CartLoadingState());
    repository.addOrRemoveCart(
     token: userToken,
      id: id,
    ).then((value){
      cartModel=CartModel.fromJson(value.data);
      if(!cartModel.status){
        changeLocalCart(id);
      }

      emit(AddToOrRemoveCartState());
    }).catchError((error){
      changeLocalCart(id);
      print(error);
      emit(CartErrorState(error));
    });
  }

  void changeLocalCart(id){
    inCart[id]=!inCart[id];
    if(inCart[id]){
      cartProductsNumber++;
    }else{
      cartProductsNumber--;
    }
  }

  void getFavorites() {
    //  emit(HomeLoadingState());
    repository.getFavorite(token: userToken).then((value){
      print(userToken);
      favoriteModel = FavoritesModel.fromJson(value.data);
     // emit(AppStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(AppStateError(error));
    });
  }

}