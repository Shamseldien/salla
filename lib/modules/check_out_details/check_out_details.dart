import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/layout/home_layout.dart';
import 'package:salla/modules/orders/bloc/cubit.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
class CheckOutDetails extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Directionality(
      textDirection: AppCubit.get(ctx).appDirection,
      child: BlocConsumer<AppCubit,AppStates>(
         listener: (context,state){
         },
         builder: (context,state){
           var cubit = AppCubit.get(context);
           return Scaffold(
             appBar: AppBar(
               elevation: 1.0,
               title: Text('${appLang(context).orderDetails}'),
             ),
             body: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                 children: [
                   Row(
                     children: [
                       Text('${appLang(context).paymentMethod}',style: black16(),),
                       SizedBox(width: 20,),
                       Text('${cubit.addOrderModel.data.paymentMethod}',style: grey14(),),

                     ],
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   Row(
                     children: [
                       Text('${appLang(context).subTotal}',style: black16(),),
                       SizedBox(width: 20,),
                       Text('${cubit.addOrderModel.data.cost.round()} ${appLang(context).currency}',style: grey14(),),

                     ],
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   Row(
                     children: [
                       Text('${appLang(context).vat}',style: black16(),),
                       SizedBox(width: 20,),
                       Text('${cubit.addOrderModel.data.vat.round()} ${appLang(context).currency}',style: grey14(),),

                     ],
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   Row(
                     children: [
                       Text('${appLang(context).disc}',style: black16(),),
                       SizedBox(width: 20,),
                       Text('${cubit.addOrderModel.data.discount} %',style: grey14(),),

                     ],
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   Row(
                     children: [
                       Text('${appLang(context).total}',style: black16(),),
                       SizedBox(width: 20,),
                       Text('${cubit.addOrderModel.data.total.round()} ${appLang(context).currency}',style: grey14(),),

                     ],
                   ),
                   Spacer(),
                   Container(
                     width: double.infinity,
                     height: 40,
                     child: MaterialButton(
                       onPressed: (){
                         cubit.continueShopping(context);
                       },
                       color:btnColor,
                       child: Text('${appLang(context).home}',
                         style: white14(),
                       ),
                     ),
                   )

                 ],
               ),
             ),
           );
         },
      ),
    );
  }
}
