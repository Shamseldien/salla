abstract class MyOrdersStates {}
class MyOrdersStateInit extends MyOrdersStates{}
class MyOrdersStateLoading extends MyOrdersStates{}
class MyOrdersStateSuccess extends MyOrdersStates{}
class MyOrdersStateError extends MyOrdersStates{
  var error;
  MyOrdersStateError(this.error);
}

class OrderDetailsStateInit extends MyOrdersStates{}
class OrderDetailsStateLoading extends MyOrdersStates{}
class OrderDetailsStateSuccess extends MyOrdersStates{}
class OrderDetailsStateError extends MyOrdersStates{
  var error;
  OrderDetailsStateError(this.error);
}

class OrderCancelStateLoading extends MyOrdersStates{}
class OrderCancelStateSuccess extends MyOrdersStates{}
class OrderCancelStateError extends MyOrdersStates{
  var error;
  OrderCancelStateError(this.error);
}