import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:salla/layout/bloc/cubit.dart';
import 'package:salla/layout/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';


class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print( AppCubit.get(context).appDirection);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(appLang(context).salla),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(5.0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: btnColor),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Icon(Icons.search),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            body: PersistentTabView(context,
             decoration: NavBarDecoration(
             borderRadius: BorderRadius.only(
               topLeft: Radius.circular(20),
               topRight: Radius.circular(20)
             ),

             ),
              screens: cubit.pages,
              items: [
              PersistentBottomNavBarItem(icon: Icon(Icons.home_outlined),title:appLang(context).home),
              PersistentBottomNavBarItem(icon: Icon(Icons.category_outlined),title: appLang(context).categories),
              PersistentBottomNavBarItem(icon: Stack(
                alignment: Alignment.topLeft,
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_bag_outlined),
                  Positioned(
                    top: -10,
                    right: -5,
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle
                        ),
                        child: Text('${AppCubit.get(context).favoriteModel.data.total}',style: white12(),)),
                  )
                ],
              ),title: appLang(context).cart),
              PersistentBottomNavBarItem(icon: Icon(Icons.settings_outlined),title: appLang(context).settings),
            ],)
          ),
        );
      },
    );
  }
}
