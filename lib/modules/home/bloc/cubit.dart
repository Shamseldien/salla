import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/banners_model/banner_model.dart';
import 'package:salla/models/categories_model/categories_model.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:salla/modules/home/bloc/states.dart';
import 'package:salla/shared/network/repository.dart';

class HomeCubit extends Cubit<HomeStates> {
  final Repository repository;

  HomeCubit({@required this.repository}) : super(HomeInitState());

  static HomeCubit get(context) => BlocProvider.of(context);

}
