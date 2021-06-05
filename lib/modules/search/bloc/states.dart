abstract class SearchStates {}
class SearchStateInit extends SearchStates{}
class SearchStateLoading extends SearchStates{}
class SearchStateSuccess extends SearchStates{}
class SearchStateError extends SearchStates{
  var error;
  SearchStateError(this.error);
}


class SearchStateOnType extends SearchStates{}
class SearchStateGetHistory extends SearchStates{}
class SearchStateClearHistory extends SearchStates{}

