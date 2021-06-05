
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/product_info/bloc/cubit.dart';
import 'package:salla/modules/product_info/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';

class ProductInfo extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<ProductInfoCubit,ProductInfoStates>(
      listener: (context,state){},
      builder: (context,state){
        var model = ProductInfoCubit.get(context).productInfo;
        return Directionality(
          textDirection: AppCubit.get(context).appDirection,
          child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: Text(state is! ProductInfoStateLoading ?model.data.name:'',overflow: TextOverflow.ellipsis,maxLines: 1,),
            ),
            body: SafeArea(
              child: ConditionalBuilder(
                  condition: state is! ProductInfoStateLoading,
                  builder: (context)=>SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 20,),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CarouselSlider.builder(
                              itemCount: model.data.images.length,
                              options: CarouselOptions(
                                  height: size.width>600?400: 200,
                                  autoPlay: true,
                                  aspectRatio: 0.8,
                                  enlargeCenterPage: true,

                              ),
                              itemBuilder: (context, index, realIdx) {
                                return Image(
                                  image: NetworkImage(model.data.images[index],),fit: BoxFit.cover,);
                              },
                            ),
                            BlocConsumer<AppCubit,AppStates>(
                              listener: (context,state){},
                              builder: (context,state){
                                return  Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    children: [
                                      CircleAvatar(
                                          backgroundColor:Colors.grey[200].withOpacity(.8),
                                          child: IconButton(
                                              icon: Icon(
                                                AppCubit.get(context).inCart[model.data.id]?Icons.shopping_bag:
                                                Icons.shopping_bag_outlined,
                                                color: AppCubit.get(context).inCart[model.data.id]?btnColor:Colors.blueGrey,
                                              ),
                                              onPressed: () {
                                                AppCubit.get(context).addOrRemoveCart(
                                                  id: model.data.id,

                                                );
                                              })),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CircleAvatar(
                                          backgroundColor:Colors.grey[200].withOpacity(.8),
                                          child: IconButton(
                                              icon: Icon(
                                                AppCubit.get(context).inFav[model.data.id]?Icons.favorite:
                                                Icons.favorite_border_outlined,
                                                color: AppCubit.get(context).inFav[model.data.id]?btnColor:Colors.blueGrey,
                                              ),
                                              onPressed: () {
                                                AppCubit.get(context).addOrRemoveFavorite(
                                                  id: model.data.id,
                                                );

                                              })),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(model.data.name,style: black16(),),
                            SizedBox(
                              height: 10,
                            ),
                            Text('${model.data.price.round()} ${appLang(context).currency}',style: black14().copyWith(
                                color: Colors.blue
                            ),),
                            if(model.data.discount>0)
                            Row(
                              children: [
                                Text('${model.data.oldPrice.round()} ${appLang(context).currency}',style: grey12().copyWith(
                                    height: 1.2,
                                    decoration: TextDecoration.lineThrough
                                ),),
                                SizedBox(width: 30,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  color: Colors.red,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(appLang(context).sale,style: white14(),),
                                      Text(' ${model.data.discount}%',style: white14()),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text('${appLang(context).description}',style: black18(),),
                            SizedBox(
                              height: 10,
                            ),
                            Text('${model.data.description}',
                                maxLines: 10,overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      )

                      ],
                    ),
                  ),
                fallback: (context)=>Center(child: loadingIndicator()),
              ),
            ),

          ),
        );
      },
    );
  }
}
