abstract class ProductInfoStates {}
class ProductInfoStateInit extends ProductInfoStates{}
class ProductInfoStateLoading extends ProductInfoStates{}
class ProductInfoStateSuccess extends ProductInfoStates{}
class ProductInfoStateError extends ProductInfoStates{
  var error;
  ProductInfoStateError(this.error);
}