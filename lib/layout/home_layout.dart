import 'package:conditional_builder/conditional_builder.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/bloc/cubit.dart';
import 'package:salla/layout/bloc/states.dart';
import 'package:salla/modules/cart/cart.dart';
import 'package:salla/modules/favorites/favorites.dart';
import 'package:salla/modules/search/bloc/cubit.dart';
import 'package:salla/modules/search/bloc/states.dart';
import 'package:salla/modules/search/search_screen.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/network/remote/network_connection.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class HomeLayout extends StatelessWidget {
  var searchCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {

        var cubit = AppCubit.get(context);
        // cubit.networkListener().then((value) {
        //   cubit.subscription.cancel();
        // });
        return Directionality(
          textDirection: AppCubit.get(context).appDirection,
          child: Scaffold(
              // appBar: cubit.currentIndex!=3 && AppCubit.get(context).myFavoritesModel!=null
              appBar: cubit.currentIndex == 3
                  ? AppBar(
                      title: Text('${appLang(context).settings}'),
                      elevation: 0.5,
                    )
                  : AppBar(
                      title: Row(
                        children: [
                          Image(
                            width: 70,
                            image: AssetImage(
                              AppCubit.get(context).isDark
                                  ? 'assets/images/sallawhite.png'
                                  :'assets/images/sallablack.png',
                            ),

                          ),

                          // Text(appLang(context).salla),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: searchCon,
                              onTap: (){
                                SearchCubit.get(context).getHistory();
                              },
                              decoration: InputDecoration(
                                hintText: '${appLang(context).search}',
                                hintStyle: grey14(),
                                isDense: true,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 15.0
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: btnColor.withOpacity(0.50))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: btnColor.withOpacity(0.50))),
                              ),
                              onChanged: (value) {
                                if (value.length > 0) {
                                  cubit.changeIsType(true);
                                } else {
                                  cubit.changeIsType(false);
                                }
                              },
                              onFieldSubmitted: (text) {
                                if(text.length>0)
                                  SearchCubit.get(context)
                                    .searchProduct(text: text.toString())
                                    .then((value) {
                                  navigateTo(context: context, widget: SearchScreen());
                                  cubit.changeIsType(false);
                                  searchCon.clear();
                                });
                              },
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
                                navigateTo(
                                    context: context, widget: CartScreen());
                              },
                              icon: Icon(Icons.shopping_cart_outlined),
                            ),
                            if (AppCubit.get(context).cartProductsNumber > 0)
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
                                    AppCubit.get(context).cartProductsNumber >=
                                            9
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
                selectedItemColor: cubit.bottomColors[cubit.currentIndex],
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
              body:Stack(
                children: [
               cubit.pages[cubit.currentIndex],
                  if (cubit.isType && SearchCubit.get(context).recent!=null && SearchCubit.get(context).recent.length>0 )
                   BlocConsumer<SearchCubit,SearchStates>(
                       listener: (context,state){},
                       builder: (context,state){
                         return  Positioned(
                           top: -15,
                           left: 30,
                           right: 0,
                           child: Align(
                             alignment: Alignment.topCenter,
                             child: Container(
                               width: 210,
                               height: 200,
                               child: Card(
                                 child: Padding(
                                   padding: const EdgeInsets.all(10.0),
                                   child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Expanded(
                                         child: Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: ListView.builder(
                                             shrinkWrap: true,
                                             itemBuilder: (context, index) => InkWell(
                                               onTap: (){
                                                 SearchCubit.get(context)
                                                     .searchProduct(text: SearchCubit.get(context).recent[index].toString())
                                                     .then((value) {
                                                   navigateTo(context: context, widget: SearchScreen());
                                                   cubit.changeIsType(false);
                                                   searchCon.clear();
                                                 });
                                               },
                                               child: Row(
                                                 children: [
                                                   Icon(IconBroken.Time_Circle),
                                                   SizedBox(
                                                     width: 20,
                                                   ),
                                                   Text('${SearchCubit.get(context).recent[index]}')
                                                 ],
                                               ),
                                             ),
                                             itemCount: SearchCubit.get(context).recent.length,
                                           ),
                                         ),
                                       ),
                                       InkWell(
                                           onTap: (){
                                             SearchCubit.get(context).clearHistory();
                                           },
                                           child: Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Icon(IconBroken.Delete),
                                           ))
                                     ],
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         );
                       },
                   )
                ],
              )),
        );
      },
    );
  }
}
