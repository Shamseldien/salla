import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/address/address_screen.dart';
import 'package:salla/modules/authentication/login/login.dart';
import 'package:salla/modules/cart/cart.dart';
import 'package:salla/modules/orders/my_orders.dart';
import 'package:salla/modules/profile/profile.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){

        },
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return Directionality(
            textDirection: AppCubit.get(context).appDirection,
            child: Center(
              child: SingleChildScrollView(
                child: ConditionalBuilder(
                    condition: cubit.userModel!=null,
                    builder: (context)=>Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage('${cubit.userModel.data.image}')
                              ),
                              borderRadius:BorderRadius.circular(10.0)
                          ),
                        ),
                        Text('${cubit.userModel.data.name}',),
                        Text('${cubit.userModel.data.email}',style: TextStyle(height: 1),),
                        SizedBox(height: 20,),
                        settingsItem(
                          function: (){
                            navigateTo(context: context, widget: ProfileScreen());
                          },
                          text: '${appLang(context).editProf}',
                          icon: IconBroken.Edit_Square,
                          iconColor: Colors.green,
                        ),
                        SizedBox(height: 5,),
                        settingsItem(
                          function: (){
                            navigateTo(context: context, widget: MyOrdersScreen());
                          },
                          text: '${appLang(context).orders}',
                          icon: IconBroken.Bag,
                          iconColor: Colors.deepOrange,
                        ),
                        SizedBox(height: 5,),
                        settingsItem(
                          function: (){
                            navigateTo(context: context, widget: CartScreen());
                          },
                          text: '${appLang(context).cart}',
                          icon: IconBroken.Buy,
                          iconColor: Colors.deepPurpleAccent,
                        ),
                        SizedBox(height: 5,),
                        settingsItem(
                          function: (){
                            navigateTo(context: context, widget: AddressScreen());
                          },
                          text: '${appLang(context).addresses}',
                          icon: IconBroken.Paper_Negative,
                          iconColor: Colors.blue,
                        ),
                        SizedBox(height: 5,),
                        settingsItem(
                          function: (){
                            showDialog(
                              context: context,
                              builder: (context)=>AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content: Directionality(
                                  textDirection: cubit.appDirection,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width:200,
                                            height: 100,
                                            child: ListView.separated(
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
                                                itemCount:languageList.length),
                                          ),
                                          Align(
                                            alignment: AlignmentDirectional.bottomEnd,
                                            child: TextButton(
                                                onPressed: (){
                                                  int selectedIndex = cubit.selectedLanguageIndex;
                                                  var model = languageList;
                                                  if (selectedIndex == null)
                                                  {
                                                    showToast(
                                                      text: '${appLang(context).langError}',
                                                      color: toastMessagesColors.WARNING,
                                                    );
                                                  }else{
                                                    saveLanguageCode(model[selectedIndex].code).then((value){
                                                      getTranslationFile(model[selectedIndex].code).then((value){
                                                        cubit.setAppLanguage(
                                                            translationFile:value,
                                                            code: model[selectedIndex].code
                                                        ).then((value){
                                                          cubit..getHomeData()..getCategories()..getCartInfo()..getFavorites()..getAddress()..getUserInfo();
                                                          Navigator.pop(context);
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
                                                }
                                                ,child: Text('${appLang(context).done}')),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ),
                            );
                          },
                          text: '${appLang(context).language}',
                          icon: Icons.language,
                          iconColor: Colors.orange,
                        ),
                        SizedBox(height: 5,),
                        settingsItem(
                          text: '${appLang(context).darkMode}',
                          icon: Icons.brightness_6,
                          iconColor: Colors.teal,
                          suffix: CupertinoSwitch(
                            activeColor: Colors.teal,
                            value: cubit.isDark,
                            onChanged: (value){
                              print('settValue==>$value');
                              cubit.changeAppTheme(value: value);
                            },
                          ),
                        ),
                        SizedBox(height: 5,),
                        settingsItem(
                          function: (){},
                          text: '${appLang(context).aboutUs}',
                          icon: IconBroken.More_Square,
                          iconColor: Colors.pinkAccent,
                        ),

                        SizedBox(height: 5,),
                        settingsItem(
                          function: (){
                            cubit.userLogout(context);

                          },
                          text: '${appLang(context).logOut}',
                          icon: IconBroken.Logout,
                          iconColor: Colors.cyan,
                        ),
                        SizedBox(height: 10,),
                        Divider(
                          height: 2,
                        ),
                        SizedBox(height: 10,),
                        //  Text('${appLang(context).contactUs}',style: black16(),),
                        // GridView.builder(
                        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //       childAspectRatio: 1.9,
                        //       crossAxisCount: 3,
                        //     ),
                        //     shrinkWrap: true,
                        //     itemBuilder: (context,index)=>contactItems(
                        //       color: cubit.contactColors[index]
                        //     ),
                        //   itemCount: 3,
                        //
                        // ),


                        Container(
                          width: 150,
                          child: Image(
                            image: AssetImage(
                              AppCubit.get(context).isDark
                                  ? 'assets/images/sallawhite.png'
                                  :'assets/images/sallablack.png',
                            ),

                          ),
                        ),
                        Text('${appLang(context).rights}'),

                        SizedBox(height: 10,),

                      ],
                    ),
                    if(state is UserLogoutLoadingState)
                      loadingIndicator()
                  ],
                ),
                  fallback: (context)=>Center(child: loadingIndicator()),
                )

              ),
            ),
          );
        },
    );
  }

}
