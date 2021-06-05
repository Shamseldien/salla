import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:salla/models/single_category/single_cat_model.dart';
import 'package:salla/modules/single_category/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';

class SingleCatCubit extends Cubit<SingleCatStates>{
  Repository repository;
  SingleCatCubit({this.repository}) : super(SingleCatStateInit());
   static SingleCatCubit get(context)=>BlocProvider.of(context);

   SingleCatModel singleCatModel;
  getSingleCategory(int id, context)
  {
    emit(SingleCatStateLoading());

    repository
        .getSingleCategory(token: userToken, id: id)
        .then((value)
    {
      singleCatModel = SingleCatModel.fromJson(value.data);

      singleCatModel.data.data.forEach((element)
      {
        if(!AppCubit.get(context).inFav.containsKey(element.id))
        {
          AppCubit.get(context).inFav.addAll({
            element.id: element.inFavorites
          });
        }

        if(!AppCubit.get(context).inCart.containsKey(element.id))
        {
          AppCubit.get(context).inCart.addAll({
            element.id: element.inCart
          });

          if(element.inCart)
          {
            AppCubit.get(context).cartProductsNumber++;
          }
        }

      });

      emit(SingleCatStateSuccess());

      print(value.data.toString());
    }).catchError((error) {
      print(error.toString());
      emit(SingleCatStateError(error.toString()));
    });
  }


   }




