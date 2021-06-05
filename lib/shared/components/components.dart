import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:salla/models/address/address_model.dart';
import 'package:salla/models/board/board_model.dart';
import 'package:salla/models/cart/my_cart_model.dart';
import 'package:salla/models/categories_model/categories_model.dart';
import 'package:salla/models/order_details/order_details_model.dart';
import 'package:salla/models/orders/orders_model.dart';
import 'package:salla/models/search_model/search_model.dart';
import 'package:salla/modules/check_out_details/check_out_details.dart';
import 'package:salla/models/home_model/home_models.dart';
import 'package:salla/modules/authentication/bloc/cubit.dart';
import 'package:salla/modules/authentication/bloc/states.dart';
import 'package:salla/modules/boarding/boarding.dart';
import 'package:salla/modules/order_details/orders_details_screen.dart';
import 'package:salla/modules/product_info/bloc/cubit.dart';
import 'package:salla/modules/product_info/product_info.dart';
import 'package:salla/modules/single_category/bloc/cubit.dart';
import 'package:salla/modules/single_category/single_category.dart';
import 'package:salla/shared/app_cubit/app_cubit.dart';
import 'package:salla/shared/app_cubit/app_states.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/di/di.dart';
import 'package:salla/shared/language/language_model.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/icon_broken.dart';
import 'package:salla/shared/style/styles.dart';

class LanguageModel {
  final String language;
  final String code;

  LanguageModel({
    this.language,
    this.code,
  });
}

List<LanguageModel> languageList = [
  LanguageModel(code: 'ar', language: 'العربيه'),
  LanguageModel(code: 'en', language: 'English'),
];
Widget paymentBuilder({context,function,text,icon,value})=> Card(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    child: Row(
      children: [
        Text(text,),
        Spacer(),
        Container(child: icon),
        Checkbox(
            activeColor: Colors.green,
            value: value, onChanged: function),
      ],
    ),
  ),
);


Widget cartBuilder(CartItems model,context)=>InkWell(
  onTap: (){
    navigateTo(context: context, widget: ProductInfo());
    ProductInfoCubit.get(context)..getProductInfo(productId: model.product.id).then((value) {

    });
  },
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
            top: 10,
            bottom: 30,
            end: 20,
            start: 10
        ),
        child: Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: Container(
                    height:120,
                    width: 110,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Image(image: NetworkImage(model.product.image),fit: BoxFit.cover,)),
              ),
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
                                Text(' ${appLang(context).currency}',style: black12().copyWith(color: Colors.blue),),
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
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: btnColor,
                                  width: 0.5
                              )
                          ),
                          child: IconButton(
                              padding: EdgeInsets.all(3),
                              icon: Icon(Icons.remove,size: 10,), onPressed: (){
                            if(model.quantity>1)
                              AppCubit.get(context).updateCart(
                                  id: model.id,
                                  quantity: --model.quantity
                              );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: Text('${model.quantity}',style: black18().copyWith(color: Colors.blue),),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: btnColor,
                                  width: 0.5
                              )
                          ),
                          child: IconButton(
                              padding: EdgeInsets.all(3),
                              icon: Icon(Icons.add,size: 12,), onPressed: (){
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
    ),
  ),
);
Widget orderSuccess({msg,context})=>Column(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment:
  MainAxisAlignment.center,
  children: [
    Card(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
                'assets/images/done.png'),
          ),
          Text(
            '$msg',
            style: black16(),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding:
            const EdgeInsets.all(
                8.0),
            child: Container(
              decoration:
              BoxDecoration(
                borderRadius:
                BorderRadius
                    .circular(20),
                color: btnColor,
              ),
              height: 35,
              width: 200,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        20)),
                onPressed: () {
                  Navigator.pop(
                      context);
                  navigateToAndFinish(context: context, widget: CheckOutDetails());


                },
                child: Text(
                  '${appLang(context).continueShop}',
                  style: white14(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
              20)),
    )
  ],
);
Widget addressBuilder({Address address,context,bool isSelected,selectAdd,})=> Card(
  child: InkWell(
    onTap: selectAdd,
    child: Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLang(context).shippingCity,),
                      SizedBox(height: 5,),
                      Text(appLang(context).shippingRegion,),
                      SizedBox(height: 5,),
                      Text(appLang(context).shippingAddressDetails,),
                      SizedBox(height: 5,),
                      Text(appLang(context).shippingNotes,),
                    ],
                  ),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${address.city}',style: grey14(),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        SizedBox(height: 5,),
                        Text('${address.region}',style: grey14(),maxLines: 1,overflow: TextOverflow.ellipsis),
                        SizedBox(height: 5,),
                        Text('${address.details}, ${address.region}, ${address.city}',style: grey14(),maxLines: 1,overflow: TextOverflow.ellipsis),
                        SizedBox(height: 5,),
                        Text('${address.notes}',style: grey14(),maxLines: 1,overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: Icon(Icons.edit,color: Colors.green,), onPressed: (){

                  }),
                  IconButton(icon: Icon(Icons.delete_forever,
                    color: btnColor,
                  ),
                      onPressed: (){

                    AppCubit.get(context).deleteAdd(id: address.id);
                    AppCubit.get(context).addressLength=null;

                      }),
                ],
              )
            ],
          ),
        ),
        if(isSelected)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.check_circle,color: Colors.green,),
          )
      ],
    ),
  ),
);


Widget ordersItem({context, MyOrdersDetails data,})=> Padding(
  padding: const EdgeInsets.all(10.0),
  child: Column(
    children: [
      Card(
        elevation: 2.0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('${appLang(context).total}',style: black18(),),
                      Spacer(),
                      Text('${data.total.round()} ${appLang(context).currency}',style: grey14(),)
                    ],
                  ),
                  Row(
                    children: [
                      Text('${appLang(context).date}',style: black18(),),
                      Spacer(),
                      Text('${data.date}',style: grey14(),)
                    ],
                  ),
                  Row(
                    children: [
                      Text('${appLang(context).orderStatus}',style: black18(),),
                      Spacer(),
                      Text('${data.status}',style: grey14(),)
                    ],
                  ),

                ],
              ),
            ),
            Container(
                width: double.infinity,
                color: Colors.indigo,
                child: TextButton(onPressed: (){
                  navigateTo(context: context, widget: OrdersDetailsScreen(id: data.id,));
                }, child: Text('${appLang(context).orderDetails}',style: white16(),)))

          ],
        ),
      ),
    ],
  ),
);

Widget orderDetailsItem({context,OrderProducts order})=>Card(
  elevation: 2.0,
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('${order.image}')
            )
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('${order.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: black14().copyWith(height: 1.5),
            ),
            Row(
              children: [
                Text('${appLang(context).price}',),
                Spacer(),
                Text('${order.price} ${appLang(context).currency}',style: grey14(),),
              ],
            ),
            Row(
              children: [
                Text('${appLang(context).quantity}',),
                Spacer(),
                Text('${order.quantity}',style: grey14()),
              ],
            ),

          ],
        )),
      ],
    ),
  ),
);

Widget searchItem({SearchResults searchData,index,context})=>Card(
  elevation: 2.0,
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 80,
          width: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('${searchData.image}')
              )
          ),
        ),
        SizedBox(height: 5,),
        Text('${searchData.name}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: black14().copyWith(height: 1.5),
        ),
        Spacer(),
        Row(
          children: [
            Text('${appLang(context).price}',),
            Spacer(),
            Text('${searchData.price} ${appLang(context).currency}',style: grey14(),),
          ],
        ),

      ],
    ),
  ),
);


Widget searchItemTwo({SearchResults searchData,index,context})=>Container(
  child: Card(
    child: Row(
      children: [
        Container(
          // height: 30,
          width: 65,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('${searchData.image}')
            )
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: 10,
              end: 5,
              bottom: 2,
              start: 5
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${searchData.name}',maxLines: 2,overflow: TextOverflow.ellipsis,style: black14().copyWith(
                  height: 1.5
                ),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text('${appLang(context).price}',maxLines: 2,overflow: TextOverflow.ellipsis,style: white12(),),
                    SizedBox(width: 5,),
                    Expanded(child: Text('${searchData.price.round()} ${appLang(context).currency}',style: grey12(),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    ),
  ),
);

Widget languageItem({LanguageModel model, index, context}) => InkWell(
      onTap: () {
        AppCubit.get(context).changeSelectedLanguage(index);
      },
      borderRadius: BorderRadius.circular(20.0),
      splashColor: Colors.green,
      child: Container(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(model.language),
              Spacer(),
              if (AppCubit.get(context).selectedLanguage[index])
                Icon(Icons.language),
            ],
          ),
        ),
      ),
    );

enum toastMessagesColors {
  SUCCESS,
  ERROR,
  WARNING,
}
Widget productItem({context, Products product,index,})=>InkWell(
  onTap: (){
    navigateTo(context: context, widget: ProductInfo());
    ProductInfoCubit.get(context)..getProductInfo(productId: product.id).then((value) {

    });
  },

  child:   Container(
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),

                        ),
                      image: DecorationImage(image: NetworkImage(
                          product.image),fit: BoxFit.cover)
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
                                    AppCubit.get(context).inCart[product.id] !=null&& AppCubit.get(context).inCart[product.id]?Icons.shopping_bag:
                                  Icons.shopping_bag_outlined,
                                  color: AppCubit.get(context).inCart[product.id] !=null&&AppCubit.get(context).inCart[product.id]?btnColor:Colors.blueGrey,
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
                                    AppCubit.get(context).inFav[product.id]!=null&& AppCubit.get(context).inFav[product.id]?Icons.favorite:
                                  Icons.favorite_border_outlined,
                                  color:AppCubit.get(context).inFav[product.id]!=null&& AppCubit.get(context).inFav[product.id]?btnColor:Colors.blueGrey,
                                ),
                                onPressed: () {
                                  AppCubit.get(context).addOrRemoveFavorite(
                                    id: product.id,
                                  );
                                })),
                      ],
                    ),
                  ),
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
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                  black16().copyWith(height: 1.5),
                ),
                SizedBox(
                  height: 5,
                ),
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
                  '${product.price.toString()} ${appLang(context).currency}',
                  style: black14()
                      .copyWith(color: Colors.blue),
                ),
                if( product.oldPrice>0)
                  Text(
                    '${product.oldPrice.toString()} ${appLang(context).currency}',
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




Widget noData(context)=>Center(child: Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Image(image: AssetImage('assets/images/emptyfav.png'),),
    SizedBox(height: 10,),
    Text('${appLang(context).noProduct}',style: black18(),)
  ],
),);

Widget categoryWidget({ProductData model,context})=>InkWell(
  onTap: (){
    //print(model.id);
    navigateTo(context: context, widget: SingleCategory(catName: model.name,));
    di<SingleCatCubit>()..getSingleCategory(model.id, context);
  },
  child:   Container(
    height: 90,
    child:Center(
      child: ListTile(
        title: Text(model.name),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        leading: Container(
          height: 90,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('${model.image}')
            )
          ),
        ),
      ),
    ),
  ),
);
Color setToastColor(toastMessagesColors color) {
  Color c;
  switch (color) {
    case toastMessagesColors.ERROR:
      c = Colors.red;
      break;
    case toastMessagesColors.SUCCESS:
      c = Colors.green;
      break;
    case toastMessagesColors.WARNING:
      c = Colors.amber;
      break;
  }
  return c;
}

void showToast({
  @required String text,
  @required toastMessagesColors color,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: setToastColor(color),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future navigateTo({
  @required context,
  @required widget,
}) async {
  return Navigator.push(
      context,
      PageTransition(
          child: widget,
          type: PageTransitionType.slideZoomRight,
          duration: Duration(milliseconds: 900)));
}

Future navigateToAndFinish({
  @required context,
  @required widget,
}) async {
    return Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            child: widget,
            type: PageTransitionType.slideZoomLeft,
            duration: Duration(milliseconds: 900)),
            (route) => false);

}
Widget settingsItem({text,iconColor,icon,function,suffix})=> ListTile(
  onTap: function,
  hoverColor: iconColor,
  title: Text('$text',style: black14(),),
  leading: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: iconColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Icon(icon,color: iconColor,)),
  trailing: suffix??Icon(appLanguage=='en' ? IconBroken.Arrow___Right_2 : IconBroken.Arrow___Left_2),
);


Widget boardingItem({@required BoardModel model, index,context}) => Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
            image: AssetImage('${model.image}')),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: model.title,
              style: TextStyle(
                  color: defaultColor.withOpacity(0.50), fontSize: 25),
              children: <TextSpan>[
                TextSpan(
                    text: '\n${model.subTitle1}',
                    style: TextStyle(
                        color: index != 2 || appLanguage == 'ar'
                            ? defaultColor.withOpacity(0.50)
                            : defaultColor,
                        fontWeight:
                            index == 2 ? FontWeight.bold : FontWeight.normal)),
                TextSpan(
                    text: '  ${model.subTitle2}',
                    style: TextStyle(
                        color: index != 2 || appLanguage == 'ar'
                            ? defaultColor
                            : defaultColor.withOpacity(0.50),
                        fontWeight: index != 2 || appLanguage == 'ar'
                            ? FontWeight.bold
                            : FontWeight.normal)),
              ],
            ),
          ),
        ),
      ],
    );

Widget defaultTextFormField({
  @required hint,
  @required error,
  @required controller,
  @required context,
  bool isPass =false,
  showPassFunction,
  IconData icon,
  textStyle,

}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        cursorHeight: 25,
        cursorColor: btnColor,
        validator: (value) {
          if (value.isEmpty) return error;
          return null;
        },

        controller: controller,
        obscureText:isPass,
        style:textStyle ?? black16(),
        decoration: InputDecoration(
          suffixIcon: icon!=null ? Directionality(
              textDirection: AppCubit.get(context).appDirection,
              child: InkWell(
                  onTap: showPassFunction,
                  child: Icon(icon,color: Colors.grey,))) : null,
          hintText: hint,
          hintStyle: grey14(),
          isDense: true,
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: btnColor.withOpacity(0.50))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: btnColor.withOpacity(0.50))),
        ),
      ),
    );

Widget socialButton({@required function, @required text, @required icon}) =>
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Container(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Colors.grey[200])),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Image(
                  image: AssetImage('$icon'),
                  height: 45,
                  width: 50,
                ),
              ),
              SizedBox(
                width: 30.0,
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );

Widget logo({TextStyle textStyle, iconColor = Colors.white}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_bag_outlined,
          color: iconColor,
          size: 50,
        ),
        Text(
          'Salla Store',
          style: textStyle ?? white22(),
        ),
      ],
    ),
  );
}

Widget defaultBtn({
  @required text,
  @required function,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: btnColor,
        ),
        width: double.infinity,
        height: 40.0,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: function,
          child: Text(
            text,
            style: white14(),
          ),
        ),
      ),
    );


Widget loadingIndicator({color})=>Center(
  child: LoadingBouncingGrid.square(
    borderColor: Colors.white,
    borderSize: 1.0,
    size: 80.0,
    backgroundColor: color ?? btnColor,
    duration: Duration(milliseconds: 1500),
  ),
);

Widget chooseImageDialog({context})=>Container(
  decoration: BoxDecoration(
    border:Border.all(color: Colors.white),
    borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        topLeft: Radius.circular(30.0)

    ),
  ),
  child:   Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 100,
        height: 5,
        color: Colors.blueGrey,
      ),
      ListTile(
        leading:
        Icon(IconBroken.Camera),
        title: Text('${appLang(context).cam}'),
        onTap: (){
          AuthCubit.get(context).getImage(source: ImageSource.camera);
          Navigator.pop(context);
        },
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0)
          ),
        ) ,
      ),
      ListTile(
        leading: Icon(IconBroken.Image),
        title: Text('${appLang(context).gallery}'),
        onTap: (){
          AuthCubit.get(context).getImage(source: ImageSource.gallery);
          Navigator.pop(context);
        },
      )
    ],
  ),
);




