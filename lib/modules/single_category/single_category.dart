import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:salla/models/single_category/single_cat_model.dart';
import 'package:salla/modules/product_info/product_info.dart';
import 'package:salla/modules/single_category/bloc/cubit.dart';
import 'package:salla/modules/single_category/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
class SingleCategory extends StatelessWidget {
  var catName;
  var id;
  SingleCategory({this.catName,this.id});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>di<SingleCatCubit>()..getSingleCategory(catId: id),
    child: BlocConsumer<SingleCatCubit,SingleCatStates>(
        listener: (context,state){},
        builder: (context,state){
          var model = SingleCatCubit.get(context).singleCatModel;
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              title: Text(catName),
            ),
            body: ConditionalBuilder(
                condition: state is! SingleCatStateLoading,
                builder: (context)=>ConditionalBuilder(
                    condition: model.data.data.isNotEmpty,
                    builder: (context)=> Column(
                      children: [
                        SizedBox(height: 10,),
                        Expanded(
                          child: StaggeredGridView.countBuilder(
                            crossAxisCount: 2,
                            physics: BouncingScrollPhysics(),
                            itemCount: model.data.data.length,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            itemBuilder: (BuildContext context, int index) {
                              return singleCatItems(
                                  context: context,
                                  index: index,
                                  product: model.data.data[index]
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
                      ],
                    ),
                  fallback: (context)=>Center(child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 20.0),
                    child: Image(image: AssetImage('assets/images/noproduct.png')),
                  ),),
                ),
              fallback: (context)=>Center(child: loadingIndicator(),),),
          );
        },

    ),
    );
  }

  Widget singleCatItems({Products product,index,context})=>InkWell(
   onTap: () {
     navigateTo(context: context, widget: ProductInfo(id: product.id,));
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
                          image: NetworkImage(
                              product.image),
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
                                        AppCubit.get(context).inCart[product.id]?Icons.shopping_bag:
                                        Icons.shopping_bag_outlined,
                                        color: AppCubit.get(context).inCart[product.id]?btnColor:Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        AppCubit.get(context).addOrRemoveCart(
                                          id: product.id,

                                        );
                                      })),
                              SizedBox(
                                height: 10,
                              ),
                              CircleAvatar(
                                  backgroundColor:Colors.grey[200].withOpacity(.8),
                                  child: IconButton(
                                      icon: Icon(
                                        AppCubit.get(context).inFav[product.id]?Icons.favorite:
                                        Icons.favorite_border_outlined,
                                        color: AppCubit.get(context).inFav[product.id]?btnColor:Colors.blueGrey,
                                      ),
                                      onPressed: () {
                                        AppCubit.get(context).addOrRemoveFavorite(
                                          id: product.id,
                                        );
                                      })),
                            ],
                          ),
                        );
                      },
                    )
                  ),
                  if(product.discount>0)
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
                            Text('${product.discount.toString()}%',style: white12(),),
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
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                    black14().copyWith(height: 1.5),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${product.price.toString()} SAR',
                    style: black14()
                        .copyWith(color: Colors.blue),
                  ),
                  if( product.oldPrice>0)
                    Text(
                      '${product.oldPrice.toString()} SAR',
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
}
