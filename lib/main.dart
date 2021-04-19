import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/bloc/cubit.dart';
import 'package:salla/layout/home_layout.dart';
import 'package:salla/modules/authentication/login/login.dart';
import 'package:salla/modules/select_laguage/select_lang.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/styles.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  appLanguage = await getLangCode();
  userToken = await getUserToken();
  String translationFile = await  getTranslationFile(appLanguage);

  Widget start;
  if(userToken!=null && appLanguage !=null){
    start = HomeLayout();
  }else if(appLanguage != null && userToken == null){
    start = LoginScreen();
  }else{
    start = SelectLanguage();
  }

  runApp(MyApp(
    transFile: translationFile,
    code: appLanguage,
    start: start,
  ));
}

class MyApp extends StatelessWidget {
  final String transFile;
  final String code;
  Widget start;
  MyApp({@required this.transFile,this.code,this.start});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>di<AppCubit>()..setAppLanguage(
            translationFile: transFile,
            code: code
        )..getCategories()..getHomeData()),
      ],
      child: BlocConsumer<AppCubit,AppStates>(
          listener: (context,state){},
          builder: (context,state){
            print(code);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightThem(),
              home: Directionality(
                  textDirection: AppCubit.get(context).appDirection,
                  child: start),
            );
          },
      )
    );
  }
}
