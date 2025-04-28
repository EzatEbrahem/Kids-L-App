import 'dart:io';

abstract class AuthenticationEvent{

}
class EmailAndPasswordSignInAuthenticationEvent extends AuthenticationEvent {
  final String email;
  final String password;
  EmailAndPasswordSignInAuthenticationEvent(this.email, this.password);
}
class SignUpAuthenticationEvent extends AuthenticationEvent {
  final File? image;
  final String userName;
  final String email;
  final String password;
  final String phone;
  SignUpAuthenticationEvent(
      this.image, this.userName, this.email, this.password, this.phone);
}
class StoreUserDataEvent extends AuthenticationEvent {
  final String userId;
  final File? image;
  final String userName;
  final String email;
  final String phone;
  StoreUserDataEvent(
      this.image, this.userName, this.email,  this.phone, this.userId);
}
class GoogleSignInAuthenticationEvent extends AuthenticationEvent {}
class FacebookSignInAuthenticationEvent extends AuthenticationEvent {}
class LogOutAuthenticationEvent extends AuthenticationEvent {}
class LoadUserDataEvent extends AuthenticationEvent {}
class ForgetPasswordAuthenticationEvent extends AuthenticationEvent {
  final String email;
  ForgetPasswordAuthenticationEvent(this.email);
}
class TakePictureFromCameraEvent extends AuthenticationEvent{}
class SelectPictureFromGalleryEvent extends AuthenticationEvent{}
class ResetSignUpEvent extends AuthenticationEvent{}
class TogglePasswordVisibilityEvent extends AuthenticationEvent {}
