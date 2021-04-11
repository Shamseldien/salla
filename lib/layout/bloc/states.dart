abstract class HomeLayoutStates {}
class HomeLayoutInitState extends HomeLayoutStates{}
class HomeLayoutLoadingState extends HomeLayoutStates{}
class HomeLayoutSuccessState extends HomeLayoutStates{}
class ChangeIndex extends HomeLayoutStates{}
class HomeLayoutErrorState extends HomeLayoutStates{
  var error;
  HomeLayoutErrorState(this.error);
}