import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kids_learning/Authentication/Domain/entities/user_entities.dart';
import 'package:kids_learning/core/error/failure.dart';

abstract class BaseAuthenticationRepository{
  Future<Either<Failure,void>> signUpAuthentication(UserData user,File? image);
  Future<Either<Failure,UserData>> emailAndPasswordSignInAuthentication(SignInParameters parameters);
  Future<Either<Failure,UserData>> googleSignInAuthentication();
  Future<Either<Failure,UserData>> facebookSignInAuthentication();
  Future<Either<Failure,String>> forgetPasswordAuthentication(String email);
  Future<Either<Failure,UserData>> getUserData();
  Future<Either<Failure,String>> logOutAuthentication();
}
class SignInParameters extends Equatable{
  final String email;
  final String password;

  const SignInParameters(this.email, this.password);

  @override
  // TODO: implement props
  List<Object?> get props => [email,password];


}