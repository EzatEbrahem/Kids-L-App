
import 'package:dartz/dartz.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

import '../../../core/error/failure.dart';
import '../entities/user_entities.dart';
import '../repository/base_authentication_repository.dart';
class EmailAndPasswordSignInUseCase extends BaseUseCase<UserData,SignInParameters,NoParameters>{
  final BaseAuthenticationRepository baseAuthenticationRepository;
   EmailAndPasswordSignInUseCase(this.baseAuthenticationRepository);
   @override
  Future<Either<Failure,UserData>>call(SignInParameters parameter,NoParameters noParameter)async {
   return await baseAuthenticationRepository.emailAndPasswordSignInAuthentication(parameter);
  }
}