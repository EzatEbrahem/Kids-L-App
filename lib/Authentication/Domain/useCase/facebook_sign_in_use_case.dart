
import 'package:dartz/dartz.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

import '../../../core/error/failure.dart';
import '../entities/user_entities.dart';
import '../repository/base_authentication_repository.dart';

class FacebookSignInUseCase extends BaseUseCase<UserData,NoParameters,NoParameters>{
  final BaseAuthenticationRepository baseAuthenticationRepository;
   FacebookSignInUseCase(this.baseAuthenticationRepository);
   @override
  Future<Either<Failure,UserData>>call(NoParameters parameter,NoParameters noParameter)async {
   return await baseAuthenticationRepository.facebookSignInAuthentication();
  }
}