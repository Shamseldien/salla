import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/boarding/boarding.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/local/cash_helper.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class SelectLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<AppCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit = AppCubit.get(context);
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please select your language',
                          style: black20(),
                        ),
                        Container(
                            width: double.infinity,
                            child: Text(
                              'من فضلك إختار اللغه المناسبه',
                              style: black20(),
                              textAlign: TextAlign.end,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                               languageItem(
                                 context: context,
                                 index: index,
                                 model: languageList[index]
                               ),
                            separatorBuilder: (context, index) =>
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                  ),
                                ),
                            itemCount:languageList.length)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: double.infinity,

                      child: MaterialButton(
                        height: 45.0,
                        onPressed: () {
                          int selectedIndex = AppCubit.get(context).selectedLanguageIndex;
                          var model = languageList;
                          if (selectedIndex == null)
                          {
                            showToast(
                              text: 'please select a language then press done',
                              color: toastMessagesColors.WARNING,
                            );
                          }else{
                            saveLanguageCode(model[selectedIndex].code).then((value){
                              getTranslationFile(model[selectedIndex].code).then((value){
                                cubit.setAppLanguage(
                                    translationFile:value,
                                  code: model[selectedIndex].code
                                ).then((value){
                                  navigateTo(
                                      context: context,
                                      widget: BoardingScreen(),);
                                }).catchError((error){
                                  print('error1====>$error');
                                });
                              }).catchError((error){
                                print('error2====>$error');
                              });
                            }).catchError((error){
                              print('error3====>$error');
                            });

                          }

                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        color: Colors.blue,
                        child: Text(
                          'NEXT',
                          style: white16(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
      ),
    );
  }
}
