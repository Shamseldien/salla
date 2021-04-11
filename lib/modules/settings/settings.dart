import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return Column(
            children: [
              MaterialButton(onPressed: (){
                saveLanguageCode('en').then((value){
                  getTranslationFile('en').then((value){
                    cubit.setAppLanguage(
                        translationFile:value,
                        code: 'en'
                    );
                  }).catchError((error){
                    print('error2====>$error');
                  });
                }).catchError((error){
                  print('error3====>$error');
                });

              },child: Text('change lang'),)
            ],
          );
        },
    );
  }
}
