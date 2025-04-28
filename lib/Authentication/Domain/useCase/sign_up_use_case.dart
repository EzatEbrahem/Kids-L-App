import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:kids_learning/Authentication/Domain/repository/base_authentication_repository.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

import '../../../core/error/failure.dart';
import '../entities/user_entities.dart';

class SignUpUseCase extends BaseUseCase<void,UserData,File?>{
final BaseAuthenticationRepository baseAuthenticationRepository;
 SignUpUseCase(this.baseAuthenticationRepository);
@override
Future<Either<Failure,void>>call(UserData userData,File? image)async {
return await baseAuthenticationRepository.signUpAuthentication(userData,image);
}
}