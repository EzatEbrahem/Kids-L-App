
import 'package:dartz/dartz.dart';
import 'package:kids_learning/core/usecase/base_usecase.dart';

import '../../../core/error/failure.dart';
import '../repository/base_authentication_repository.dart';

class ForgetPasswordUseCase extends BaseUseCase<String,String,NoParameters>{
  final BaseAuthenticationRepository baseAuthenticationRepository;
  ForgetPasswordUseCase(this.baseAuthenticationRepository);
   @override
  Future<Either<Failure,String>>call(String email,NoParameters noParameter)async {
   return await baseAuthenticationRepository.forgetPasswordAuthentication(email);
  }
}