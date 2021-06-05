import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:salla/layout/home_layout.dart';
import 'package:salla/modules/authentication/bloc/cubit.dart';
import 'package:salla/modules/authentication/bloc/states.dart';
import 'package:salla/modules/authentication/login/login.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/network/local/cash_helper.dart';
import 'package:salla/shared/network/repository.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';
import 'package:salla/testPage.dart';

class SignUpScreen extends StatelessWidget {
  var nameCon = TextEditingController();
  var emailCon = TextEditingController();
  var phoneCon = TextEditingController();
  var passwordCon = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit(repository: di<Repository>()),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              di<CashHelper>()
                  .put(
                  key: USER_TOKEN_KEY,
                  value: state.userInfoModel.data.token)
                  .then((value)async {
                await getUserToken().then((value){
                  userToken = value;
                  AppCubit.get(context)..changeIndex(0)..getHomeData()
                    ..getCategories()
                    ..getCartInfo()
                    ..getFavorites()
                    ..getAddress()
                    ..getUserInfo();
                });
                di<CashHelper>()
                    .put(key: USER_Model_Info_KEY, value: state.userInfoModel)
                    .then((value) {
                  navigateToAndFinish(
                      context: context, widget: HomeLayout());
                }).catchError((error) {
                  print('error token');
                });
              }).catchError((error) {
                print('error model');
              });
            }
          },
          builder: (context, state) {
            return Directionality(
              textDirection: AppCubit.get(context).appDirection,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),
                body: SafeArea(
                  child: Stack(
                    children: [
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AuthCubit.get(context).image!=null
                              ? Builder(
                                builder:(context)=> Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10.0)),
                                        child: Image(
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                          image: FileImage(AuthCubit.get(context).image),
                                        )
                                    ),
                                    Positioned(
                                      left: -10,
                                      top: -10,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey.withOpacity(.50),
                                        radius: 18.0,
                                        child:IconButton(onPressed: (){
                                          AuthCubit.get(context).chooseSourceImageDialog(context);
                                        },icon: Icon(IconBroken.Camera,size: 18,),) ,
                                      ),
                                    )
                                  ],
                                ),
                              )
                                  :Builder(
                                    builder:(context)=> InkWell(
                                      onTap: (){
                                       AuthCubit.get(context).chooseSourceImageDialog(context);
                                      },
                                      child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Image(
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/images/avatar.png'),
                                      )
                              ),
                                    ),
                                  ),
                              if(di<AuthCubit>().image != null)
                              TextButton(onPressed: (){}, child: Text('change Image')),
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    defaultTextFormField(
                                      hint: appLang(context).userName,
                                      error: appLang(context).userNameError,
                                      controller: nameCon,
                                      context: context,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    defaultTextFormField(
                                      hint: appLang(context).email,
                                      error: appLang(context).emailError,
                                      controller: emailCon,
                                      context: context,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    defaultTextFormField(
                                      hint: appLang(context).phone,
                                      error: appLang(context).phoneError,
                                      controller: phoneCon,
                                      context: context,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    defaultTextFormField(
                                        error: appLang(context).passError,
                                        hint: appLang(context).password,
                                        controller: passwordCon,
                                        isPass:
                                            !AuthCubit.get(context).isShow,
                                        context: context,
                                        icon: AuthCubit.get(context).isShow
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        showPassFunction: () {
                                          AuthCubit.get(context).togglePass();
                                        }),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    defaultBtn(
                                        text: appLang(context).signUp,
                                        function: () {
                                          if (formKey.currentState
                                              .validate()) {
                                            AuthCubit.get(context)
                                                .userRegistration(
                                              email: emailCon.text,
                                              phone: phoneCon.text,
                                              name: nameCon.text,
                                              password: passwordCon.text,
                                            );
                                          }
                                        }),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    appLang(context).member,
                                    style: grey14(),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        navigateTo(
                                          context: context,
                                          widget: LoginScreen(),
                                        );
                                      },
                                      child: Text(
                                        appLang(context).signIn,
                                        style: TextStyle(color: btnColor),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      if (state is AuthLoadingState) loadingIndicator(),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
