import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salla/layout/home_layout.dart';
import 'package:salla/models/add_cart/cart_model.dart';
import 'package:salla/models/add_order/add_order_model.dart';
import 'package:salla/models/address/address_model.dart';
import 'package:salla/models/cart/my_cart_model.dart';
import 'package:salla/models/categories_model/categories_model.dart';
import 'package:salla/models/add_favorites/favorites_model.dart';
import 'package:salla/models/favorites/my_favorites_model.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:salla/models/promo_estimate/promo_estimate_model.dart';
import 'package:salla/models/promo_validate/promo_validate.dart';
import 'package:salla/models/user_info/user_info_model.dart';
import 'package:salla/modules/authentication/login/login.dart';
import 'package:salla/modules/categories/categories.dart';
import 'package:salla/modules/favorites/favorites.dart';
import 'package:salla/modules/home/home.dart';
import 'package:salla/modules/search/bloc/cubit.dart';
import 'package:salla/modules/settings/settings.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/language/language_model.dart';
import 'package:salla/shared/network/remote/network_connection.dart';
import 'package:salla/shared/network/repository.dart';

class AppCubit extends Cubit<AppStates> {
  Repository repository;

  AppCubit({this.repository}) : super(AppStateInit());

  static AppCubit get(context) => BlocProvider.of(context);

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

  bool isDark = false;

  Future changeAppTheme({bool value}) async {
    await saveThemeMode(isDark: value);
    this.isDark = value;
    emit(ChangeThemeState());
  }

  Future setAppTheme() async {
    isDark = await getThemeMode() ?? false;
    emit(ChangeThemeState());
  }

  AppLanguageModel appLanguageModel;

  TextDirection appDirection = TextDirection.ltr;

  Future<void> setAppLanguage({translationFile, code}) async {
    appLanguageModel = AppLanguageModel.fromJson(jsonDecode(translationFile));
    appDirection = await code == 'ar' ? TextDirection.rtl : TextDirection.ltr;
    emit(AppSetLanguageState());
  }

  CategoriesModel categoriesModel;
  HomeModel homeModel;
  FavoritesModel favoriteModel;
  MyFavoritesModel myFavoritesModel;
  AddressModel addressModel;
  CartModel cartModel;
  MyCartModel myCartModel;
  AddOrderModel addOrderModel;
  UserInfoModel userModel;
  PromoValidateModel promoValidateModel;
  PromoEstimateModel promoEstimateModel;
  int cartProductsNumber = 0;
  int favProductsNumber = 0;
  Map<int, bool> inCart = {};
  Map<int, bool> inFav = {};
  List<Color> bottomColors = [
    Colors.deepOrangeAccent,
    Colors.teal,
    Colors.red,
    Colors.orange,
  ];

  List contactColors = [
    Colors.blueAccent,
    HexColor('#8a3ab9'),
    Colors.cyan,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.indigo,
  ];

  int currentIndex = 0;

  void changeIndex(index) {
    currentIndex = index;
    emit(ChangeIndex());
  }

  List<Widget> pages = [
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  int selectedAdd = 0;
  int addressLength;

  void selectAddress(index) {
    selectedAdd = index;
    emit(SelectAddressState());
  }

  bool isType = false;

  void changeIsType(bool isTyping) {
    isType = isTyping;
    print(isType);
    emit(SearchStateOnType());
  }

  Future getAddress() async {
    //  emit(HomeLoadingState());
    if (userToken != null && userToken != '')
      repository.getAddresses(token: userToken).then((value) {
        addressModel = AddressModel.fromJson(value.data);
        // print(addressModel.data.data[0].name);
        addressLength = addressModel.data.data.length;
        emit(AppStateSuccess());
      }).catchError((error) {
        print(error.toString());
        emit(AppStateError(error));
      });
  }

  void deleteAdd({id}) {
    emit(AddressLoadingState());
    repository.deleteAddress(token: userToken, id: id).then((value) {
      //  print(value.data);
      getAddress();
      emit(DeleteAddressSuccessState());
    }).catchError((error) {
      print(error);
      emit(DeleteAddressErrorState(error));
    });
  }

  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var pass = TextEditingController();

  void continueShopping(context) {
    changeIndex(0);
    navigateAndFinish(context: context, widget: HomeLayout());
    emit(BackHomeState());
  }

  Future getUserInfo() async {
    print(userToken);
    if (userToken != null) {
      return await repository
          .getUserProfile(
        token: userToken,
      )
          .then((value) {
        userModel = UserInfoModel.fromJson(value.data);
        if (userModel.status) {
          name.text = userModel.data.name;
          email.text = userModel.data.email;
          phone.text = userModel.data.phone;
          emit(AppStateSuccess());
        } else {
          print(userModel.message);
          emit(AppStateError(userModel.message));
        }
      }).catchError((error) {
        print('profileError$error}');
        emit(AppStateError(error));
      });
    }
  }

  Future validatePromo({promo}) async {
    emit(ValidatePromoLoading());
    return await repository
        .promoValidate(token: userToken, promo: promo)
        .then((value) async {
      promoValidateModel = PromoValidateModel.fromJson(value.data);
      if (promoValidateModel.status) {
        print(value.data);
        await estimateOrderCost().then((value) {
          emit(ValidatePromoSuccess());
        });
      } else {
        print(value.data);
        emit(ValidatePromoError(promoValidateModel.message));
      }
    }).catchError((error) {
      emit(ValidatePromoError(error));
    });
  }

  Future estimateOrderCost() async {
    return await repository
        .estimateOrderCost(
            token: userToken, promoId: promoValidateModel.data.id)
        .then((value) {
      promoEstimateModel = PromoEstimateModel.fromJson(value.data);
      if (promoEstimateModel.status) {
        print(promoEstimateModel.data.total);
        emit(EstimatePromoSuccess());
      } else {
        print(promoEstimateModel);
        emit(EstimatePromoError(promoEstimateModel.message));
      }
    }).catchError((error) {
      print(error);
      emit(EstimatePromoError(error));
    });
  }

  void userLogout(context) {
    emit(UserLogoutLoadingState());
    repository.userLogout(token: userToken).then((value) {
      print(value.data.toString());
      deleteUserToken();
      deleteSearchHistory().then((value) {
        SearchCubit.get(context).recent.clear();
      });
      navigateAndFinish(context: context, widget: LoginScreen());
      emit(UserLogoutState());
    });
  }

  Future checkOut({addressId, promo}) async {
    emit(CheckOutLoadingState());
    return await repository
        .confirmOrder(
            token: userToken,
            addressId: addressId,
            payMethod: 1,
            points: false,
            promo: promoValidateModel.data.id)
        .then((value) {
      //
      if (value.data['status'] == true) {
        //  print(value.data);
        addOrderModel = AddOrderModel.fromJson(value.data);
        cartProductsNumber = 0;
        favProductsNumber = 0;
        getCartInfo();
        getHomeData();
        emit(CheckOutSuccessState());
      } else {
        print('error');
        print(value.data);
        addOrderModel = AddOrderModel.fromJson(value.data);
        emit(CheckOutErrorState('error'));
      }
    }).catchError((error) {
      print(error);
      emit(CheckOutErrorState(error));
    });
  }

  void getCategories() {
    emit(AppStateLoading());
    if (userToken != null && userToken != '')
      repository.getCategories().then((value) {
      //  print('categoriesData==>>${value.data}');
        categoriesModel = CategoriesModel.fromJson(value.data);
        //print(categoriesModel.status);
        //emit(AppStateSuccess());
      }).catchError((error) {
        print('categoriesError==>>${error.toString()}');
        emit(AppStateError(error));
      });
  }

  void getHomeData() {
    //  emit(AppStateLoading());
    inFav.clear();
    inCart.clear();
    cartProductsNumber = 0;
    favProductsNumber = 0;
    if (userToken != null && userToken != '')
      repository.getHomeData(token: userToken).then((value) {
      //  print('homeData=>>${value.data}');
        homeModel = HomeModel.fromJson(value.data);
        homeModel.data.products.forEach((element) {
          inCart.addAll({element.id: element.inCart});
          inFav.addAll({element.id: element.inFavorites});
          if (element.inCart) cartProductsNumber++;
          if (element.inFavorites) favProductsNumber++;
        });
        emit(AppStateSuccess());
      }).catchError((error) {
        print('homeDataError==>>${error.toString()}');
        emit(AppStateError(error));
      });
  }

  void addOrRemoveFavorite({id}) {
    changeLocalFav(id);
    emit(FavLoadingState());
    repository
        .addOrRemoveFav(
      token: userToken,
      id: id,
    )
        .then((value) {
      favoriteModel = FavoritesModel.fromJson(value.data);
      if (!favoriteModel.status) {
        changeLocalFav(id);
      }
      getFavorites();
      emit(AddToOrRemoveFavState());
    }).catchError((error) {
      changeLocalFav(id);
      print(error.toString());
      emit(FavErrorState(error));
    });
  }

  void addOrRemoveCart({id}) {
    changeLocalCart(id);
    emit(CartLoadingState());
    repository
        .addOrRemoveCart(
      token: userToken,
      id: id,
    )
        .then((value) {
      cartModel = CartModel.fromJson(value.data);
      if (!cartModel.status) {
        changeLocalCart(id);
      }
      getCartInfo();
      emit(AddToOrRemoveCartState());
    }).catchError((error) {
      changeLocalCart(id);
      print(error);
      emit(CartErrorState(error));
    });
  }

  void updateCart({id, int quantity}) {
    emit(UpdateCartLoadingState());
   // print('updateCartToken===>> $userToken');
    repository
        .updateCart(token: userToken, id: id, quantity: quantity)
        .then((value) {
      getCartInfo();
    }).catchError((error) {
      print(error);
      emit(CartErrorState(error));
    });
  }

  void getCartInfo() {
    emit(GetCartInfoLoading());
    if (userToken != null && userToken != '')
      repository
          .getCartInfo(
        token: userToken,
      )
          .then((value) {
       // print('Cart==>>${value.data}');
        myCartModel = MyCartModel.fromJson(value.data);
        if (myCartModel.status) {
          emit(GetCartInfoSuccess());
        } else {
          emit(GetCartInfoError('cart error'));
        }
      }).catchError((error) {
        print('cartError==>>${error.toString()}');
        emit(GetCartInfoError(error));
      });
  }

  void getFavorites() {
    //  emit(HomeLoadingState());
    if (userToken != null && userToken != '')
      repository.getFavorite(token: userToken).then((value) {
       // print('favData==>>${value.data}');
        myFavoritesModel = MyFavoritesModel.fromJson(value.data);
        if (myFavoritesModel.status) {
          emit(AppStateSuccess());
        } else {
          emit(AppStateError('fav error'));
        }
      }).catchError((error) {
        print('favError==>>${error.toString()}');
        emit(AppStateError(error));
      });
  }

  void changeLocalCart(id) {
    inCart[id] = !inCart[id];
    if (inCart[id]) {
      cartProductsNumber++;
    } else {
      cartProductsNumber--;
    }
  }

  void changeLocalFav(id) {
    inFav[id] = !inFav[id];
    if (inFav[id]) {
      favProductsNumber++;
    } else {
      favProductsNumber--;
    }
  }

  bool isConnected = false;


void checkConnection(ConnectivityResult result){
    final hasInternet = result!= ConnectivityResult.none;
     if(hasInternet) {
       isConnected = true;
       reloadData();
     }else{
       isConnected = false;

     }
emit(ConnectionStatusListenerState());
}

  StreamSubscription subscription;

  Future networkListener()async{
    subscription =
        Connectivity().onConnectivityChanged.listen(checkConnection);
    emit(ConnectionStatusListenerState());
}


void reloadData(){
  getHomeData();
  getCategories();
  getCartInfo();
  getFavorites();
  getAddress();
  getUserInfo();
}


}
