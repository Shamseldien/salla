
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/cart/my_cart_model.dart';
import 'package:salla/modules/product_info/product_info.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return BlocConsumer<AppCubit,AppStates>(
       listener: (context,state){},
       builder: (context,state){
         var model = AppCubit.get(context).myCartModel;
         return ConditionalBuilder(
             condition: model!=null,
             builder: (context)=>Column(
               children: [
                 if(state is UpdateCartLoadingState)
                 LinearProgressIndicator(
                   backgroundColor: Colors.grey[300],
                   valueColor: AlwaysStoppedAnimation<Color>(btnColor),
                 ),
                 Expanded(
                   child: Stack(
                     alignment: Alignment.bottomCenter,
                     children: [
                       ListView.separated(
                         physics: BouncingScrollPhysics(),
                         itemBuilder: (context,index)=>cartBuilder(model.data.cartItems[index],context),
                         separatorBuilder: (context,index)=>Container(height: 1,width: double.infinity,color: Colors.grey[200],),
                         itemCount: model.data.cartItems.length,
                       ),
                       MaterialButton(
                         color: btnColor,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20),
                           ),
                           child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Text('Check out',style: white16(),),
                               SizedBox(width: 10,),
                               Icon(Icons.arrow_forward,color: Colors.white,size: 20,)
                             ],
                           ),
                           onPressed: (){

                       })
                     ],
                   ),
                 ),
               ],
             ),
           fallback: (context)=>Center(child: loadingIndicator(),),
         );
       },
   );
  }


  Widget cartBuilder(CartItems model,context)=>InkWell(
    onTap: (){
      navigateTo(context: context, widget: ProductInfo(id: model.product.id,));
    },
    child: Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 30,
        left: 10,
        right: 10
      ),
      child: Container(
        child: Row(
          children: [
            Container(
                height:120,
                width: 110,
                child: Image(image: NetworkImage(model.product.image))),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.product.name,overflow: TextOverflow.ellipsis,maxLines: 2,),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(model.product.price.round().toString(),style: black14().copyWith(color: Colors.blue),),
                              Text(' SAR',style: black12().copyWith(color: Colors.blue),),
                            ],
                          ),
                          if(model.product.discount>0)
                            Row(
                              children: [
                                Text(model.product.oldPrice.round().toString(),style: black12().copyWith(

                                    color: Colors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough
                                ),),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  child: Container(
                                    width: 1.0,
                                    height: 10.0,
                                    color: Colors.grey,
                                  ),
                                ),

                                Text('${model.product.discount}%',style: black12().copyWith(color: Colors.red),),

                              ],
                            ),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: btnColor,
                        child: IconButton(icon: Icon(Icons.remove,size: 15,), onPressed: (){
                         if(model.quantity>1)
                           AppCubit.get(context).updateCart(
                               id: model.id,
                               quantity: --model.quantity
                           );
                        }),
                      ),
                      SizedBox(width: 5,),
                      Text('${model.quantity}',style: black18().copyWith(color: Colors.blue),),
                      SizedBox(width: 5,),
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: btnColor,
                        child: IconButton(icon: Icon(Icons.add,size: 15,), onPressed: (){
                          AppCubit.get(context).updateCart(
                              id: model.id,
                              quantity: ++model.quantity
                          );
                        }),
                      ),

                    ],
                  )
                ],
              ),
            )
          ],
        ),

      ),
    ),
  );
}
