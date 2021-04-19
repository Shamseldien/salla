
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/product/product_info_model.dart';
import 'package:salla/modules/product_info/bloc/states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';

class ProductInfoCubit extends Cubit<ProductInfoStates>{
  Repository repository;
  ProductInfoCubit({this.repository}) : super(ProductInfoStateInit());
   static ProductInfoCubit get(context)=>BlocProvider.of(context);

  ProductInfoModel productInfo;
   void getProductInfo({productId}){
     emit(ProductInfoStateLoading());
     repository.getProductInfo(
       id: productId,
       token: userToken,
     ).then((value){
       productInfo = ProductInfoModel.fromJson(value.data);
       print(productInfo.data.name);
       emit(ProductInfoStateSuccess());
     }).catchError((error){
       print(error.toString());
       emit(ProductInfoStateError(error));
     });


   }




}