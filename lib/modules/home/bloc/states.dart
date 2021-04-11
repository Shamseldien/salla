abstract class HomeStates {}
class HomeInitState extends HomeStates{}
class HomeLoadingState extends HomeStates{}
class HomeSuccessState extends HomeStates{}
class HomeErrorState extends HomeStates{
  var error;
  HomeErrorState(this.error);
}

