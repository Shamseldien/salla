import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/orders/bloc/cubit.dart';
import 'package:salla/modules/orders/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/styles.dart';
class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyOrdersCubit.get(context)..getOrders();
   return Directionality(
     textDirection: AppCubit.get(context).appDirection,
     child: BlocConsumer<MyOrdersCubit,MyOrdersStates>(
       listener: (context,state){},
       builder: (context,state){
         var cubit = MyOrdersCubit.get(context);
         return Scaffold(
           appBar: AppBar(
             elevation: 1.0,
             title: Text('${appLang(context).orders}'),
           ),
           body: ConditionalBuilder(
               condition: state is! MyOrdersStateLoading,
               builder: (context)=> ConditionalBuilder(
                 condition: cubit.ordersModel.data.data.length>0,
                 builder: (context)=>ListView.builder(
                   itemCount: cubit.ordersModel.data.data.length,
                   itemBuilder: (context,index)=>ordersItem(
                     context:context,
                     data : cubit.ordersModel.data.data[index],
                   ),

                 ),
                 fallback: (context)=>Center(child:  Column(
                   mainAxisSize: MainAxisSize.min,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Image(image: AssetImage('assets/images/emptystate.png')),
                     Text('${appLang(context).emptyOrder}'),
                   ],
                 ),),
               ),
             fallback: (context)=>Center(
               child: loadingIndicator()
             ),

           ),
         );
       },
     ),
   );
  }
}
