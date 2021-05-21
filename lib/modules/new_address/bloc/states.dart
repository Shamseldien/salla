abstract class NewAddressStates {}
class NewAddressStateInit extends NewAddressStates{}
class NewAddressStateLoading extends NewAddressStates{}
class NewAddressStateSuccess extends NewAddressStates{}
class NewAddressStateError extends NewAddressStates{
  var error;
  NewAddressStateError(this.error);
}