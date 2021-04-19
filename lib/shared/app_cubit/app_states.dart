abstract class AppStates {}
class AppStateInit extends AppStates{}
class AppStateLoading extends AppStates{}
class AppStateSuccess extends AppStates{}
class AppStateError extends AppStates{
  var error;
  AppStateError(this.error);
}
class AppStateSelectLang extends AppStates{}
class AppStateStatusBarColor extends AppStates{}
class AppSetLanguageState extends AppStates{}
class ChangeIndex extends AppStates{}


class AddToOrRemoveCartState extends AppStates{}
class CartLoadingState extends AppStates{}
class CartErrorState extends AppStates{
  var error;
  CartErrorState(this.error);
}
class AddToOrRemoveFavState extends AppStates{}
class FavLoadingState extends AppStates{}
class FavErrorState extends AppStates{
  var error;
  FavErrorState(this.error);
}