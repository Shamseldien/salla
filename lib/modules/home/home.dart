import 'package:flutter/material.dart';
import 'package:salla/models/categories_model/categories_model.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:salla/modules/home/bloc/cubit.dart';
import 'package:salla/modules/home/bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return BlocConsumer<AppCubit,AppStates>(
       listener: (context,state){},
       builder: (context,state){
        // var bannerModel=AppCubit.get(context).bannersModel;
         var catModel=AppCubit.get(context).categoriesModel;
         var homeModel=AppCubit.get(context).homeModel;
         return SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               CarouselSlider.builder(
                 itemCount: homeModel.data.banners.length,
                 options: CarouselOptions(
                   height: 180,
                   autoPlay: true,
                   aspectRatio: 0.8,
                 // enlargeCenterPage: true,
                 ),
                 itemBuilder: (context, index, realIdx) {
                   return Image(image: NetworkImage(homeModel.data.banners[index].image),fit: BoxFit.cover,);
                 },
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Text(
                   appLang(context).discover,
                   style: black18(),
                 ),
               ),
               SizedBox(
                 height: 5,
               ),
               Container(
                 height: 100,
                 padding: EdgeInsets.all(10.0),
                 child: ListView.separated(
                   scrollDirection: Axis.horizontal,
                   itemCount: 6,
                   itemBuilder: (context, index) => categoryItems(catModel.data.data[index]),
                   separatorBuilder: (context, int index) => SizedBox(
                     width: 10.0,
                   ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Text(
                   appLang(context).newArrival,
                   style: black18(),
                 ),
               ),
               SizedBox(
                 height: 10,
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: GridView.count(
                   physics: NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                   mainAxisSpacing: 5,
                   crossAxisSpacing: 5,
                   childAspectRatio: 0.6,
                   crossAxisCount: 2,
                   children: List.generate(10, (index) => productItem(context:context,product:homeModel.data.products[index]),
                   ),
                 ),
               ),
               if(state is HomeLoadingState)
                 loadingIndicator()
             ],
           ),
         );
       },
   );
  }
}

Widget categoryItems(ProductData model) => Stack(
  alignment: AlignmentDirectional.bottomCenter,
  children: [
    Container(
      width: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  model.image))),
    ),
    Container(
      width: 90,
      height: 25,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(.50),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          )),
      child: Text(
        model.name,
        style: white12(),
        textAlign: TextAlign.center,
      ),
    ),
  ],
);

Widget productItem({context, Products product})=>Column(
  children: [
    Expanded(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            child: Image(
              image: NetworkImage(
                  product.image),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [

                  CircleAvatar(
                      backgroundColor:Colors.grey[200].withOpacity(.8),
                      child: IconButton(
                          icon: Icon(
                            product.inCart?Icons.shopping_bag:
                            Icons.shopping_bag_outlined,
                            color: product.inCart?btnColor:Colors.blueGrey,
                          ),
                          onPressed: () {})),
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                      backgroundColor:Colors.grey[200].withOpacity(.8),
                      child: IconButton(
                          icon: Icon(
                            product.inFavorites?Icons.favorite:
                            Icons.favorite_border_outlined,
                            color: product.inFavorites?btnColor:Colors.blueGrey,
                          ),
                          onPressed: () {})),
                ],
              ),
            ),
          ),
          if(product.discount>0)
          Container(
            padding: EdgeInsets.all(5.0),
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
          )
        ],
      ),
    ),
    Container(
     color: Colors.grey[200].withOpacity(.25),
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
);