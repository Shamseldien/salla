import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/bloc/states.dart';
import 'package:salla/modules/home/home.dart';
import 'package:salla/modules/settings/settings.dart';

class HomeLayoutCubit extends Cubit<HomeLayoutStates>{
  HomeLayoutCubit() : super(HomeLayoutInitState());
  static HomeLayoutCubit get(context)=>BlocProvider.of(context);

  int currentIndex=0;
 List<Widget> pages = [
   HomeScreen(),
   Center(child: Text('category')),
   Center(child: Text('cart')),
   SettingsScreen(),

 ];
  void changeIndex(index){
    currentIndex = index;
    emit(ChangeIndex());
  }

}