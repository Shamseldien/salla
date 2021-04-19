abstract class SingleCatStates {}
class SingleCatStateInit extends SingleCatStates{}
class SingleCatStateLoading extends SingleCatStates{}
class SingleCatStateSuccess extends SingleCatStates{}
class SingleCatStateError extends SingleCatStates{
  var error;
  SingleCatStateError(this.error);
}