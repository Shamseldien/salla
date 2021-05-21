import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:salla/models/categories_model/categories_model.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/single_category/single_category.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return BlocConsumer<AppCubit,AppStates>(
       listener: (context,state){},
       builder: (context,state){
         var catModel=AppCubit.get(context).categoriesModel;
         var homeModel=AppCubit.get(context).homeModel;
         return Center(
           child: SingleChildScrollView(
             child: ConditionalBuilder(
                 condition: homeModel!=null && catModel!=null,
                 builder: (context)=> Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     SizedBox(height: 10,),
                     CarouselSlider.builder(
                       itemCount: homeModel.data.banners.length,
                       options: CarouselOptions(
                           height: 180,
                           autoPlay: true,
                           aspectRatio: 0.8,
                           enlargeCenterPage: true
                         // enlargeCenterPage: true,
                       ),
                       itemBuilder: (context, index, realIdx) {
                         return Image(image: NetworkImage(homeModel.data.banners[index].image),fit: BoxFit.cover,);
                       },
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                       child: Text(
                         appLang(context).discover,
                         style: black18(),
                       ),
                     ),

                     Container(
                       height: 100,
                       padding: EdgeInsets.all(10.0),
                       child: ListView.separated(
                         scrollDirection: Axis.horizontal,
                         itemCount: 6,
                         itemBuilder: (context, index) => categoryItems(catModel.data.data[index],context),
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
                         children: List.generate(10, (index) => productItem(
                             context:context,
                             product:homeModel.data.products[index],
                             index: index
                         ),
                         ),
                       ),
                     ),
                   ],
                 ),
               fallback: (context)=>Center(child: loadingIndicator(),),
             )

           ),
         );
       },
   );
  }
}

Widget categoryItems(ProductData model,context) => InkWell(
  onTap: (){
    navigateTo(context: context, widget: SingleCategory(id: model.id,catName: model.name,));
  },
  child:   Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Container(
        width: 90,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey[200]
          ),
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
  ),
);

