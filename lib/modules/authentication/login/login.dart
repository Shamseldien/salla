import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:salla/layout/home_layout.dart';
import 'package:salla/modules/authentication/bloc/cubit.dart';
import 'package:salla/modules/authentication/bloc/states.dart';
import 'package:salla/modules/authentication/sign_up/sign_up_screen.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/network/local/cash_helper.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
import 'package:salla/shared/components/components.dart';

class LoginScreen extends StatelessWidget {
  var emailCon = TextEditingController();
  var passCon = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: AppCubit.get(context).appDirection,
        child: BlocProvider(
          create: (context) => di<AuthCubit>(),
          child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is AuthSuccessState) {
                di<CashHelper>()
                    .put(
                        key: USER_Model_Info_KEY,
                        value: state.userInfoModel)
                    .then((value) {
                  di<CashHelper>()
                      .put(
                          key: USER_TOKEN_KEY,
                          value: state.userInfoModel.data.token)
                      .then((value) {
                    navigateToAndFinish(context: context, widget: HomeLayout())
                        .catchError((error) {});
                  });
                }).catchError((error) {});
              }
            },
            builder: (context, state) {
              var cubit = AuthCubit.get(context);
              return Scaffold(
                backgroundColor: bkColor,
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 50, bottom: 80),
                                child: logo(),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(35.0),
                                      topRight: Radius.circular(35.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 300,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color:
                                                      bkColor.withOpacity(.20),
                                                  blurRadius: 2.0,
                                                  spreadRadius: 1.0)
                                            ]),
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    appLang(context).welcome,
                                                    style: black22(),
                                                  ),
                                                  Container(
                                                      width: 300.0,
                                                      child: Text(
                                                        appLang(context)
                                                            .signInTitle,
                                                        style: grey14()
                                                            .copyWith(
                                                                height: 1.2),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                ],
                                              ),
                                              defaultTextFormField(
                                                error:
                                                    appLang(context).emailError,
                                                hint: appLang(context).email,
                                                controller: emailCon,
                                                context: context,
                                              ),
                                              defaultTextFormField(
                                                  error: appLang(context)
                                                      .passError,
                                                  hint:
                                                      appLang(context).password,
                                                  controller: passCon,
                                                  isPass: !cubit.isShow,
                                                  context: context,
                                                  icon: cubit.isShow
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  showPassFunction: () {
                                                    cubit.togglePass();
                                                  }),
                                              defaultBtn(
                                                  text: appLang(context).signIn,
                                                  function: () {
                                                    if (formKey.currentState
                                                        .validate()) {
                                                      cubit.userLogin(
                                                        email: emailCon.text,
                                                        password: passCon.text,
                                                      );
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            appLang(context).newAccount,
                                            style: grey14(),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                navigateTo(
                                                  context: context,
                                                  widget: SignUpScreen(),
                                                );
                                              },
                                              child: Text(
                                                appLang(context).signUp,
                                                style:
                                                    TextStyle(color: btnColor),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (state is AuthLoadingState) loadingIndicator(),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
