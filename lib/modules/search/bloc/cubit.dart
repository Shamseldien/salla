import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/search_model/search_model.dart';
import 'package:salla/modules/search/bloc/states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';

class SearchCubit extends Cubit<SearchStates> {
  Repository repository;

  SearchCubit(this.repository) : super(SearchStateInit());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel searchModel;
  List recent=[];
  bool isType=false;



  void changeIsType(bool isTyping){
    isType = isTyping;
    print(isType);
    emit(SearchStateOnType());
  }

Future clearHistory()async{
    await deleteSearchHistory().then((value) {
      recent.clear();
      emit(SearchStateClearHistory());
    });

}


Future getHistory()async{
  await getSearchHistory().then((value)async{
    if(value!=null)
      recent = value;
      print('getHistory==>>  $recent');
      emit(SearchStateGetHistory());
  });
}

   Future searchProduct({@required text})async{
    emit(SearchStateLoading());

    if(recent.isNotEmpty && !recent.contains(text) || recent.isEmpty){
      recent.add(text);
      await saveSearchHistory(value: recent);
    }
  repository.searchProducts(
      token: userToken,
      text: text
    ).then((value)async{
   searchModel = SearchModel.fromJson(value.data);
   emit(SearchStateSuccess());
    }).catchError((error){
      print(error);
      emit(SearchStateError(error));


    });
  }



}
