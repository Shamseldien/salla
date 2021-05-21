
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/order_details/order_details_model.dart';
import 'package:salla/models/orders/orders_model.dart';
import 'package:salla/modules/orders/bloc/states.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/components/constant.dart';
import 'package:salla/shared/network/repository.dart';

class MyOrdersCubit extends Cubit<MyOrdersStates> {
  Repository repository;
  MyOrdersCubit({this.repository}) : super(MyOrdersStateInit());

  static MyOrdersCubit get(context) => BlocProvider.of(context);

  OrdersModel ordersModel;


  Future getOrders()async{
    emit(MyOrdersStateLoading());
  return await repository.getOrders(
      token: userToken
    ).then((value){
      ordersModel = OrdersModel.fromJson(value.data);
      emit(MyOrdersStateSuccess());
    }).catchError((error){
      print(error);
      emit(MyOrdersStateError(error));
    });
  }

  OrderDetailsModel orderDetailsModel;

  void getOrderDetails({orderId}) async {
    emit(OrderDetailsStateLoading());
    return await repository
        .getOrderDetails(token: userToken, orderId: orderId)
        .then((value) {
      orderDetailsModel = OrderDetailsModel.fromJson(value.data);
      emit(OrderDetailsStateSuccess());
    }).catchError((error) {
      print(error);
      emit(OrderDetailsStateError(error));
    });
  }

  Future cancelOrder({orderId}) async {
    emit(OrderCancelStateLoading());
    return await repository
        .cancelOrder(orderId: orderId, token: userToken)
        .then((vv) {
      getOrders().then((value) {
        showToast(text: '${vv.data['message']}', color: toastMessagesColors.SUCCESS);
        emit(OrderCancelStateSuccess());
      });
    }).catchError((error) {
      print(error);
      emit(OrderCancelStateError(error));
    });
  }


}