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