
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/new_address/bloc/states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';

class NewAddressCubit extends Cubit<NewAddressStates>{
  Repository repository;
  NewAddressCubit({this.repository}) : super(NewAddressStateInit());
  static NewAddressCubit get(context)=>BlocProvider.of(context);


  void addNewAddress({String name,String city,String region,String details, double latitude, double longitude,String notes}){
    emit(NewAddressStateLoading());
    repository.addAddress(
        token: userToken,
        name: name,
        city: city,
        details: details,
        latitude: latitude,
        longitude: longitude,
        notes: notes,
        region: region
    ).then((value){
      emit(NewAddressStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(NewAddressStateError(error));
    });
  }





}