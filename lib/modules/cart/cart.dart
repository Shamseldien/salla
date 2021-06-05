
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/cart/my_cart_model.dart';
import 'package:salla/modules/check_out/check_out_screen.dart';
import 'package:salla/modules/product_info/product_info.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return BlocConsumer<AppCubit,AppStates>(
       listener: (context,state){},
       builder: (context,state){
         var model = AppCubit.get(context).myCartModel;
         return Directionality(
           textDirection: AppCubit.get(context).appDirection,
           child: Scaffold(
             appBar: AppBar(
               title: Text('${appLang(context).cart}'),
               elevation: 1.0,
             ),
             body: SafeArea(
               child: ConditionalBuilder(
                   condition: model!=null,
                   builder: (context)=>ConditionalBuilder(
                       condition: model.data != null && model.data.cartItems.length>0,
                       builder:(context)=>Column(
                         children: [
                           if(state is UpdateCartLoadingState)
                             LinearProgressIndicator(
                               backgroundColor: Colors.grey[300],
                               valueColor: AlwaysStoppedAnimation<Color>(btnColor),
                             ),
                           Expanded(
                             child: ListView.separated(
                               physics: BouncingScrollPhysics(),
                               itemBuilder: (context,index)=>cartBuilder(model.data.cartItems[index],context),
                               separatorBuilder: (context,index)=>Container(height: 1,width: double.infinity,color: Colors.grey[200],),
                               itemCount: model.data.cartItems.length,
                             ),
                           ),
                           Container(
                               width: double.infinity,
                               color: Colors.grey[200],
                               height: 40,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text('${appLang(context).subTotal}:  ',style: black14().copyWith(
                                     color: Colors.black
                                   ),),
                                   Text('${model.data.subTotal.round()}${appLang(context).currency}',style: black14().copyWith(
                                     color: Colors.black
                                   ),),
                                 ],
                               ),),
                           Container(
                               width: double.infinity,
                               height: 50,
                               child: MaterialButton(
                                 child: Row(
                                   children: [
                                     Text('${appLang(context).proceedTo}',style: white16(),),
                                     Spacer(),
                                     Icon(Icons.arrow_forward,color: Colors.white,),
                                   ],
                                 ),
                                 onPressed: (){
                                   navigateTo(context: context, widget: CheckOutScreen());
                                 },color:btnColor,))
                         ],
                       ),
                     fallback: (context)=>Center(child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Image(image: AssetImage('assets/images/emptystate.png'),),
                        // SizedBox(height: 20,),
                         Text('${appLang(context).emptyCart}',style: black18(),)
                       ],
                     ),),
                   ),
                 fallback: (context)=>Center(child: loadingIndicator(),),
               ),
             )),
         );
       },
   );
  }



}
