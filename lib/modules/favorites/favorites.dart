import 'dart:ui';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:salla/modules/product_info/bloc/cubit.dart';
import 'package:salla/modules/product_info/product_info.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppCubit
          .get(context)
          .appDirection,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = AppCubit
              .get(context)
              .myFavoritesModel;
          return Scaffold(
            body: model!=null && model.data.data.isNotEmpty
                ? ConditionalBuilder(
              condition: model != null,
              builder: (context) => Column(
                children: [
                  if(state is FavLoadingState)
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(btnColor),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        physics: BouncingScrollPhysics(),
                        itemCount: model.data.data.length,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              ProductInfoCubit.get(context)..getProductInfo(productId:model.data.data[index].product.id ).then((value) {
                                navigateTo(context: context, widget: ProductInfo());
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey[200]
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child:Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0),
                                          )
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10.0),
                                                  topLeft: Radius.circular(10.0),
                                                )
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(10.0),
                                                    topLeft: Radius.circular(10.0),
                                                  ),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        model.data.data[index].product.image),
                                                  )

                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(10.0),
                                                    topLeft: Radius.circular(10.0),
                                                  )
                                              ),
                                              child:BlocConsumer<AppCubit,AppStates>(
                                                listener: (context,state){},
                                                builder: (context,state){
                                                  return  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                      children: [

                                                        CircleAvatar(
                                                            backgroundColor:Colors.grey[200].withOpacity(.8),
                                                            child: IconButton(
                                                                icon: Icon(
                                                                  AppCubit.get(context).inCart[model.data.data[index].product.id]?Icons.shopping_bag:
                                                                  Icons.shopping_bag_outlined,
                                                                  color: AppCubit.get(context).inCart[model.data.data[index].product.id]?btnColor:Colors.blueGrey,
                                                                ),
                                                                onPressed: () {
                                                                  AppCubit.get(context).addOrRemoveCart(
                                                                    id: model.data.data[index].product.id,

                                                                  );
                                                                })),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        CircleAvatar(
                                                            backgroundColor:Colors.grey[200].withOpacity(.8),
                                                            child: IconButton(
                                                                icon: Icon(
                                                                  AppCubit.get(context).inFav[model.data.data[index].product.id]?Icons.favorite:
                                                                  Icons.favorite_border_outlined,
                                                                  color: AppCubit.get(context).inFav[model.data.data[index].product.id]?btnColor:Colors.blueGrey,
                                                                ),
                                                                onPressed: () {
                                                                  AppCubit.get(context).addOrRemoveFavorite(
                                                                    id: model.data.data[index].product.id,
                                                                  );
                                                                })),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                          ),
                                          if(model.data.data[index].product.discount>0)
                                            Align(
                                              alignment: AlignmentDirectional.bottomStart,
                                              child: Container(
                                                padding: EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,

                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(appLang(context).sale,style: white12(),),
                                                    SizedBox(width: 3,),
                                                    Text('${model.data.data[index].product.discount.toString()}%',style: white12(),),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.data.data[index].product.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                            black14().copyWith(height: 1.5),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${model.data.data[index].product.price.toString()} SAR',
                                            style: black14()
                                                .copyWith(color: Colors.blue),
                                          ),
                                          if( model.data.data[index].product.oldPrice>0)
                                            Text(
                                              '${model.data.data[index].product.oldPrice.toString()} SAR',
                                              style: black12().copyWith(
                                                  color: Colors.grey,
                                                  decoration:
                                                  TextDecoration.lineThrough,
                                                  height: 1.2),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (int index) {
                          return StaggeredTile.count(
                              1, index.isOdd ? 2 : 1.7);
                        },
                        mainAxisSpacing: 15.0,
                        crossAxisSpacing: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
              fallback:(context)=>Center(child: loadingIndicator(),),
            )
            :Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: AssetImage('assets/images/emptyfav.png'),),
                SizedBox(height: 10,),
                Text('${appLang(context).emptyFav}',style: black18(),)
              ],
            ),),
          );
        },
      ),
    );
  }
}
