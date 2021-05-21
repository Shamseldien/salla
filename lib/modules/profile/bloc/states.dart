abstract class EditProfileStates {}
class EditProfileStateInit extends EditProfileStates{}
class EditProfileStateLoading extends EditProfileStates{}
class EditProfileStateSuccess extends EditProfileStates{}
class EditProfileStateError extends EditProfileStates{
  var error;
  EditProfileStateError(this.error);
}