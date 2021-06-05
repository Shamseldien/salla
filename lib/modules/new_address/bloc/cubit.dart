
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salla/modules/new_address/bloc/states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoder/geocoder.dart';

class NewAddressCubit extends Cubit<NewAddressStates>{
  Repository repository;
  NewAddressCubit({this.repository}) : super(NewAddressStateInit());
  static NewAddressCubit get(context)=>BlocProvider.of(context);

  Position position;
  Address myAddress;
  Future getGeoLocation() async {
    //print('da5l');

    await Geolocator.requestPermission().then((value) async {
      emit(GeoLocationStateLoading());
      if (await Permission.location.request().isGranted) {
        await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
            .then((value) async {
          position = value;
          print(value == null
              ? 'Unknown'
              : value.latitude.toString() + ', ' + value.longitude.toString());
          final coordinates = new Coordinates(value.latitude, value.longitude);
          var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
          myAddress = addresses.first;
          print("${myAddress.featureName} : ${myAddress.addressLine}");
          print('done');
          emit(GeoLocationStateSuccess());
        });
        print(position.latitude);
        print(position.longitude);
      }
    }).catchError((error) {
      emit(GeoLocationStateError());
    });
  }



  Future addNewAddress({String name,String city,String region,String details,String notes})async{
    emit(NewAddressStateLoading());
    await repository.addAddress(
        token: userToken,
        name: name,
        city: city,
        details: details,
        latitude: position.latitude,
        longitude: position.longitude,
        notes: notes,
        region: region
    ).then((value){
      emit(NewAddressStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(NewAddressStateError(error));
    });
  }


  Future updateAddress({String name,String city,String region,String details,String notes,id,latitude,longitude})async{
    emit(NewAddressStateLoading());
    await repository.updateAddress(
        token: userToken,
        name: name,
        city: city,
        details: details,
        latitude:  latitude,
        longitude: longitude,
        notes: notes,
        region: region,
        id: id
    ).then((value){
      emit(NewAddressStateSuccess());
    }).catchError((error){
      print(error.toString());
      emit(NewAddressStateError(error));
    });
  }





}