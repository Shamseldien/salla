import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/bloc/cubit.dart';
import 'package:salla/layout/bloc/states.dart';
import 'package:salla/modules/cart/cart.dart';
import 'package:salla/modules/favorites/favorites.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
             // appBar: cubit.currentIndex!=3 && AppCubit.get(context).myFavoritesModel!=null
                appBar:cubit.currentIndex==3
                    ?
                    AppBar(
                      title: Text('${appLang(context).settings}'),
                      elevation: 0.5,
                    )
                    :AppBar(
                title: Row(
                  children: [
                    Text(appLang(context).salla),
                    SizedBox(
                      width: 10,
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
                          navigateTo(context: context, widget: CartScreen());
                        },
                        icon: Icon(Icons.shopping_cart_outlined),
                      ),
                      if(AppCubit.get(context).cartProductsNumber>0)
                        Positioned(
                        top: 5,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: btnColor,
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
                  ),
                ],
              ),
              //    :null,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,

                onTap: (index) {
                  cubit.changeIndex(index);
                },
                selectedItemColor:cubit.bottomColors[cubit.currentIndex],
                unselectedItemColor: Colors.blueGrey,
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    label: appLang(context).home,
                    icon: Icon(IconBroken.Home),
                  ),
                  BottomNavigationBarItem(
                    label: appLang(context).categories,
                    icon: Icon(IconBroken.Category),
                  ),
                  BottomNavigationBarItem(
                    label: appLang(context).favorites,
                    icon: Icon(IconBroken.Heart),
                  ),
                  BottomNavigationBarItem(
                    label: appLang(context).settings,
                    icon: Icon(IconBroken.Setting),
                  ),
                ],
              ),
              body: cubit.pages[cubit.currentIndex]);

      },
    );
  }
}
