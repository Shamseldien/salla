import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/modules/orders/bloc/cubit.dart';
import 'package:salla/modules/orders/bloc/states.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';

class OrdersDetailsScreen extends StatelessWidget {
  int id;
  OrdersDetailsScreen({this.id});
  @override
  Widget build(BuildContext context) {
    MyOrdersCubit.get(context)..getOrderDetails(orderId: id);
    return Directionality(
      textDirection: AppCubit.get(context).appDirection,
      child: BlocConsumer<MyOrdersCubit, MyOrdersStates>(
        listener: (context, state) {
        },
        builder: (context, state) {
          var cubit = MyOrdersCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                elevation: 1.0,
                title: Text('${appLang(context).orderDetails}'),
              ),
              body: Column(
                children: [
                  if(state is OrderCancelStateLoading)
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(btnColor),
                    ),
                  Expanded(
                    child: ConditionalBuilder(
                      condition: state is! OrderDetailsStateLoading ,
                      builder: (context) => SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Card(
                                elevation: 2.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${appLang(context).subTotal}',
                                            style: black18(),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${cubit.orderDetailsModel.data.cost.round()} ${appLang(context).currency}',
                                            style: grey14(),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${appLang(context).vat}',
                                            style: black18(),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${cubit.orderDetailsModel.data.vat.round()} ${appLang(context).currency}',
                                            style: grey14(),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${appLang(context).disc}',
                                            style: black18(),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${cubit.orderDetailsModel.data.discount}%',
                                            style: grey14(),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${appLang(context).total}',
                                            style: black18(),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${cubit.orderDetailsModel.data.total.round()} ${appLang(context).currency}',
                                            style: grey14(),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${appLang(context).paymentMethod}',
                                            style: black18(),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${cubit.orderDetailsModel.data.paymentMethod}',
                                            style: grey14(),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${appLang(context).date}',
                                            style: black18(),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${cubit.orderDetailsModel.data.date}',
                                            style: grey14(),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${appLang(context).orderStatus}',
                                            style: black18(),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${cubit.orderDetailsModel.data.status} ',
                                            style: grey14(),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${appLang(context).shippingAdd}',
                                            style: black18(),
                                          ),
                                          Text(
                                            '${cubit.orderDetailsModel.data.address.details}, ${cubit.orderDetailsModel.data.address.region}, ${cubit.orderDetailsModel.data.address.city} ',
                                            style: grey14(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                '${appLang(context).products}',
                                style: black20(),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => orderDetailsItem(
                                    context: context,
                                    order:
                                        cubit.orderDetailsModel.data.products[index]),
                                itemCount:
                                    cubit.orderDetailsModel.data.products.length,
                              )
                            ],
                          ),
                        ),
                      ),
                      fallback: (context) => loadingIndicator(),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      color: btnColor,
                      child: MaterialButton(
                        child: Text('${appLang(context).cancelOrder}',
                          style: white14(),),onPressed: (){
                        cubit.cancelOrder(
                            orderId: this.id,
                        ).then((value){
                          Navigator.pop(context);
                        });
                      },))
                ],
              ));
        },
      ),
    );
  }
}
