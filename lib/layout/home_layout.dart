import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/bloc/cubit.dart';
import 'package:salla/layout/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

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
              appBar: cubit.currentIndex!=3
                  ?AppBar(
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
                actions: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          cubit.changeIndex(2);
                        },
                        icon: Icon(Icons.shopping_cart_outlined),
                      ),
                      Positioned(
                        top: 5,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.all(
                            3.0,
                          ),
                          child: Text(
                            AppCubit.get(context).cartProductsNumber >= 9
                                ? '9'
                                : AppCubit.get(context)
                                    .cartProductsNumber
                                    .toString(),
                            style: white10(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
              :null,
              bottomNavigationBar: TitledBottomNavigationBar(
                currentIndex: cubit.currentIndex,
                activeColor: cubit.bottomColors[cubit.currentIndex],
                inactiveColor: Colors.blueGrey,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: [
                  TitledNavigationBarItem(
                    title: Text(appLang(context).home),
                    icon: Icons.home_outlined,
                  ),
                  TitledNavigationBarItem(
                    title: Text(appLang(context).categories),
                    icon: Icons.category_outlined,
                  ),
                  TitledNavigationBarItem(
                    title: Text(appLang(context).cart),
                    icon: Icons.shopping_bag_outlined,
                  ),
                  TitledNavigationBarItem(
                    title: Text(appLang(context).settings),
                    icon: Icons.settings_outlined,
                  ),
                ],
              ),
              body: cubit.pages[cubit.currentIndex]),
        );
      },
    );
  }
}
