import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/address/address_model.dart';
import 'package:salla/modules/new_address/new_address_screen.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';

class CheckOutScreen extends StatelessWidget {
  var promoCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var model = AppCubit.get(context).addressModel;
        return Directionality(
          textDirection: AppCubit.get(context).appDirection,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              title: Text(appLang(context).checkOut),
            ),
            body: model!=null
              ? Column(
              children: [
                if(state is AddressLoadingState || state is CheckOutLoadingState)
                  LinearProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(btnColor),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                appLang(context).price,
                                style: black18(),
                              ),
                              Spacer(),
                              Text(
                                '${cubit.myCartModel.data.total.round()} ${appLang(context).currency}',
                                style: black14().copyWith(color: Colors.blue),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                            Text(appLang(context).promo,style: black18(),),
                            Spacer(),
                              Expanded(
                                child: Container(
                                  height: 40,
                                  child: TextFormField(
                                    cursorColor: btnColor,
                                   controller: promoCon,
                                   textAlignVertical: TextAlignVertical.center,
                                    cursorHeight: 20,
                                    maxLines: 1,
                                    enabled: cubit.promoValidateModel!=null && cubit.promoValidateModel.status && promoCon.text.isNotEmpty?false:true,
                                    decoration: InputDecoration(
                                      hintStyle: grey14(),
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.all(9),
                                      isDense: true,
                                      disabledBorder:OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.lightBlue.withOpacity(0.50))),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: btnColor.withOpacity(0.50))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: btnColor.withOpacity(0.50))),
                                    ),
                                  ),
                                ),
                              ),
                              cubit.promoValidateModel!=null && cubit.promoValidateModel.status&&promoCon.text.isNotEmpty
                              ?Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(Icons.done,color: Colors.lightBlue,))
                              :TextButton(onPressed: (){
                                cubit.validatePromo(
                                  promo:promoCon.text).then((value){
                                    if(!cubit.promoValidateModel.status){
                                      showToast(text:cubit.promoValidateModel.message,color: toastMessagesColors.ERROR);
                                    }else{
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context)=>Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Card(
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Image(image: AssetImage('assets/images/box.gif'),),
                                                    Text('${appLang(context).promoText} ${cubit.promoValidateModel.data.percentage}% ${appLang(context).disc}.'),
                                                    TextButton(onPressed: (){
                                                      Navigator.pop(context);
                                                    }, child: Text('${appLang(context).continueShop}')),
                                                  ],
                                                ),
                                              ),
                                              elevation: 2.0,
                                            ),
                                          ],
                                        ),);
                                    }

                                });

                              }, child:state is ValidatePromoLoading
                                  ?  Center(
                                  child: Container(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator())) : Text('${appLang(context).apply}'),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            appLang(context).paymentMethod,
                            style: black18(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          paymentBuilder(
                            context: context,
                            function: (value) {},
                            icon:
                                Icon(Icons.money, color: Colors.green, size: 30),
                            text: appLang(context).cash,
                            value: true,
                          ),
                          /*paymentBuilder(
                            context: context,
                            function: (value) {},
                            icon: Icon(Icons.credit_card_rounded,
                                color: Colors.green, size: 30),
                            text: appLang(context).credit,
                            value: false,
                          ),*/
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                appLang(context).shippingAddress,
                                style: black18(),
                              ),
                              Spacer(),
                              if(model!=null && model.data.data.isNotEmpty)
                                Container(
                                height: 30,
                                color: btnColor,
                                child: MaterialButton(
                                  onPressed: () {
                                    navigateTo(
                                        context: context,
                                        widget: AddNewAddress());
                                  },
                                  child: Text(
                                    appLang(context).newAddress,
                                    style: white12(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          model.data.data.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => addressBuilder(
                                      context: context,
                                      address: model.data.data[index],
                                      isSelected: cubit.selectedAdd == index
                                          ? true
                                          : false,
                                      selectAdd: () {
                                        cubit.selectAddress(index);
                                      }),
                                  itemCount: model.data.data.length,
                                )
                              : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                      height: 30,
                                      color: btnColor,
                                      child: MaterialButton(
                                        onPressed: () {
                                          navigateTo(
                                              context: context,
                                              widget: AddNewAddress());
                                        },
                                        child: Text(
                                          appLang(context).newAddress,
                                          style: white12(),
                                        ),
                                      ),
                                    ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: btnColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            if(cubit.addressLength!=null){
                              cubit.checkOut(
                                      promo: promoCon.text,
                                      addressId: cubit.addressModel.data
                                          .data[cubit.selectedAdd].id).then((value){
                                if(state is! CheckOutLoadingState && cubit.addOrderModel.status) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        promoCon.clear();
                                        return orderSuccess(
                                          msg: cubit.addOrderModel.message,
                                          context: context,
                                      );
                                      },
                                  );
                                }else if(state is! CheckOutLoadingState && !cubit.addOrderModel.status){
                                  showToast(text: '${cubit.addOrderModel.message}', color: toastMessagesColors.WARNING);
                                }
                              });
                            }else{
                              showToast(text: '${appLang(context).addressError}', color: toastMessagesColors.WARNING);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                appLang(context).pay,
                                style: white16(),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          )),
                    ),
                  ),
                )
              ],
            )
            :Center(child: loadingIndicator()),
          ),
        );
      },
    );
  }
}
