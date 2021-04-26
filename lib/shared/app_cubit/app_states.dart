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

class GetCartInfoLoading extends AppStates{}
class GetCartInfoSuccess extends AppStates{}
class GetCartInfoError extends AppStates{
  var error;
  GetCartInfoError(this.error);
}


class AddToOrRemoveCartState extends AppStates{}
class CartLoadingState extends AppStates{}
class UpdateCartLoadingState extends AppStates{}
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