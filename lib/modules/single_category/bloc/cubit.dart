import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:salla/models/single_category/single_cat_model.dart';
import 'package:salla/modules/single_category/bloc/states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';

class SingleCatCubit extends Cubit<SingleCatStates>{
  Repository repository;
  SingleCatCubit({this.repository}) : super(SingleCatStateInit());
   static SingleCatCubit get(context)=>BlocProvider.of(context);

   SingleCatModel singleCatModel;
   void getSingleCategory({catId}){
     emit(SingleCatStateLoading());
     repository.getSingleCategory(
       id: catId,
       token: userToken,
     ).then((value){
       singleCatModel = SingleCatModel.fromJson(value.data);
       emit(SingleCatStateSuccess());
     }).catchError((error){
       print(error.toString());
       emit(SingleCatStateError(error));
     });


   }




}