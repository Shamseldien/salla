import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Directionality(
        textDirection: AppCubit.get(context).appDirection,
        child: BlocProvider(
            create: (context) => AuthCubit(repository: di<Repository>()),
            child: BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {
                if (state is AuthSuccessState) {
                  di<CashHelper>().put(key: USER_Model_Info_KEY,value: state.userInfoModel).then((value) {
                    di<CashHelper>().put(key: USER_TOKEN_KEY,value: state.userInfoModel.data.token).then((value) {
                      navigateToAndFinish(context: context, widget: HomeLayout())
                          .catchError((error) {});
                    });
                  }).catchError((error) {});
                }
              },
              builder: (context, state) {
                return Scaffold(
                  body: SafeArea(
                    child: Stack(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      logo(
                                          textStyle: black20(),
                                          iconColor: bkColor),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ImageDialog());
                                        },
                                        child: Image(
                                          image: AssetImage(
                                            'assets/images/avatar.png',
                                          ),
                                          height: 80,
                                          width: 80,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Form(
                                    key: formKey,
                                    child: Column(
                                      children: [
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
                                            isPass: ! AuthCubit.get(context).isShow,
                                            context: context,
                                            icon:  AuthCubit.get(context).isShow ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                            showPassFunction: (){
                                              AuthCubit.get(context).togglePass();
                                            }
                                        ),
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
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              navigateToAndFinish(
                                  context: context, widget: LoginScreen());
                            },
                          ),
                        ),
                        if (state is AuthLoadingState)
                          loadingIndicator(),
                      ],
                    ),
                  ),
                );
              },
            )));
  }
}
